use crate::device::Concat;
use crate::{
    config::{Config, HorizontalEdge, LayoutDirection, VerticalEdge},
    device::Device,
    ui::{Height, Width},
};
use clap::Parser;
use crossterm::{terminal::WindowSize, ExecutableCommand, QueueableCommand};
use evdev::{Device as EvdevDevice, EventSummary};
use nix::{
    poll::PollTimeout,
    sys::epoll::{Epoll, EpollCreateFlags, EpollEvent, EpollFlags},
};
use ordermap::OrderMap;
use std::{io::Write, os::fd::AsRawFd, path::PathBuf};

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct Args {
    /// path to main config file
    #[arg(long, short)]
    config: Option<std::path::PathBuf>,
    /// path to device config file
    devices: Vec<std::path::PathBuf>,
}

pub struct App {
    pub args: Args,
    pub config: Config,
    running: bool,
}

impl App {
    pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
        let args = Args::parse();

        if args.devices.is_empty() {
            return Err("Error: No devices specified".into());
        }

        let config: Config = if let Some(path) = &args.config {
            toml::from_str(&std::fs::read_to_string(path)?)?
        } else {
            Config::default()?
        };

        Ok(App {
            args,
            config,
            running: true,
        })
    }

    pub fn draw(
        &self,
        device: &Device,
        stdout: &mut std::io::Stdout,
    ) -> Result<(), Box<dyn std::error::Error>> {
        let WindowSize { rows, columns, .. } = crossterm::terminal::window_size()?;

        let width = match self.config.layout.width {
            Some(Width::Fixed(width)) => width,
            Some(Width::Fill) | None => crossterm::terminal::window_size()?.columns as usize,
        };

        let height = match self.config.layout.height {
            Some(Height::Fixed(width)) => width,
            Some(Height::Auto) | None => device.command_buffer_len() + 7,
            Some(Height::Fill) => columns as usize,
        };

        let x = match self.config.layout.align.horizontal {
            HorizontalEdge::Left => 0,
            HorizontalEdge::Right => (columns as usize).saturating_sub(width),
        };

        let y = match self.config.layout.align.vertical {
            VerticalEdge::Top => 0,
            VerticalEdge::Bottom => (rows as usize).saturating_sub(height),
        };

        let draw_line = |stdout: &mut std::io::Stdout, i: usize, line: &str| {
            stdout.queue(crossterm::cursor::MoveToRow((y + i) as u16))?;
            stdout.queue(crossterm::cursor::MoveToColumn(x as u16))?;
            write!(stdout, "{line:}")?;
            Ok(()) as Result<_, Box<dyn std::error::Error>>
        };

        stdout.queue(crossterm::terminal::Clear(
            crossterm::terminal::ClearType::All,
        ))?;

        let string = format!("{:width$.height$}", device);
        let mut lines: Vec<_> = string.lines().collect();
        let line_count = lines.len();
        let first = lines.remove(0);
        let last = lines.remove(lines.len() - 1);
        if self.config.layout.direction == LayoutDirection::TopBottom {
            lines.reverse();
        }

        draw_line(stdout, 0, first)?;
        for (i, line) in lines.iter().enumerate() {
            draw_line(stdout, i + 1, line)?;
        }
        draw_line(stdout, line_count - 1, last)?;

        stdout.flush()?;

        Ok(())
    }

    pub fn run(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let mut stdout = std::io::stdout();

        let epoll = Epoll::new(EpollCreateFlags::EPOLL_CLOEXEC)?;
        let mut events = [EpollEvent::empty(); 2];

        let mut devices: OrderMap<PathBuf, (Device, EvdevDevice)> = Default::default();

        for device in self.args.devices.iter() {
            println!("Loading {}...", device.display());
            let device: Device = toml::from_str(&std::fs::read_to_string(device)?)?;

            if let Some((dev, handle)) = devices.remove(&device.path) {
                println!("Config exists, concatenating...");
                devices.insert(device.path.clone(), (dev.concat(device), handle));
            }
            else {
                println!("No config, initializing...");
                let handle = EvdevDevice::open(&device.path())?;
                handle.set_nonblocking(true)?;
                let event = EpollEvent::new(EpollFlags::EPOLLIN, handle.as_raw_fd() as u64);
                epoll.add(&handle, event)?;

                devices.insert(device.path.clone(), (device, handle));
            }
        }

        // Setup exit hook
        stdout.execute(crossterm::terminal::EnterAlternateScreen)?;
        stdout.execute(crossterm::cursor::Hide)?;
        crossterm::terminal::enable_raw_mode()?;

        fn exit() -> Result<(), Box<dyn std::error::Error>> {
            let mut stdout = std::io::stdout();
            crossterm::terminal::disable_raw_mode()?;
            stdout.execute(crossterm::cursor::Show)?;
            stdout.execute(crossterm::terminal::LeaveAlternateScreen)?;
            Ok(()) as Result<_, Box<dyn std::error::Error>>
        }

        std::panic::set_hook(Box::new(|info| {
            exit().unwrap();
            println!("{info:}");
        }));

        // Enter event loop
        while self.running {
            // Draw the first device with an active update flag
            for (_, (device, _)) in devices.iter_mut() {
                if !device.wants_update() {
                    continue;
                }

                self.draw(device, &mut stdout)?;

                break;
            }

            // Clear update flags
            for (_, (device, _)) in devices.iter_mut() {
                device.clear_wants_update();
            }

            // Wait for an event
            epoll.wait(&mut events, PollTimeout::NONE)?;

            // Handle events
            for (_, (device, handle)) in devices.iter_mut() {
                match handle.fetch_events() {
                    Ok(iterator) => {
                        for event in iterator {
                            match event.destructure() {
                                EventSummary::Key(_, code, dir) => {
                                    device.update_key(self, code, dir);
                                }
                                EventSummary::AbsoluteAxis(_, axis, value) => {
                                    device.update_axis(self, axis, value);
                                }
                                _ => (),
                            }
                        }
                    }
                    Err(e) if e.kind() == std::io::ErrorKind::WouldBlock => (),
                    Err(e) => {
                        eprintln!("{e}");
                        break;
                    }
                }
            }
        }

        exit()
    }

    pub fn quit(&mut self) {
        self.running = false;
    }
}

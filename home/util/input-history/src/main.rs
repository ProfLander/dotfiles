mod app;
mod command;
mod config;
mod device;
mod get_name_from_name;
mod keymap;
mod ui;

use std::process::ExitCode;
use app::App;

fn main() -> ExitCode {
    if let Err(e) = App::new().and_then(|mut app| app.run()) {
        eprintln!("{e:}");
        ExitCode::FAILURE
    }
    else {
        ExitCode::SUCCESS
    }
}

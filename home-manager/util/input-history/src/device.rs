use crate::{
    bracket, bracket_fill,
    command::{Combination, Command, Sequence},
    cons,
    get_name_from_name::GetNameFromName,
    keymap::Keymap,
    snoc,
    ui::{fill, trunc_l, trunc_r, DisplaySlice, DisplayWidth, Width},
    App,
};
use evdev::{AbsoluteAxisCode, KeyCode};
use nu_ansi_term::{Color, Style as AnsiStyle};
use ordermap::OrderMap;
use serde::{Deserialize, Serialize};
use std::{
    collections::{BTreeMap, BTreeSet, HashMap},
    path::{Path, PathBuf},
};
use xkbcommon::xkb::{keysym_get_name, keysym_to_utf8, KeyDirection, Keycode, Keysym, State};

#[derive(Debug, Copy, Clone)]
enum Code {
    Key(Keycode),
    AbsoluteAxis(AbsoluteAxisCode),
}

#[derive(Debug, Clone)]
struct Input {
    code: Code,
    symbol: Symbol,
    style: Option<Style>,
    consumed: bool,
}

impl std::fmt::Display for Input {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        self.style
            .or(self.symbol.style)
            .unwrap_or(Default::default())
            .paint(&self.symbol.string)
            .fmt(f)
    }
}

impl Input {
    pub fn new(code: Code, symbol: Symbol) -> Self {
        Input {
            code,
            symbol,
            style: Default::default(),
            consumed: Default::default(),
        }
    }
}

#[derive(Serialize, Deserialize)]
pub struct ConfigStyle {
    #[serde(default)]
    pub foreground: Option<Color>,

    #[serde(default)]
    pub background: Option<Color>,

    #[serde(default)]
    pub is_bold: bool,

    #[serde(default)]
    pub is_dimmed: bool,

    #[serde(default)]
    pub is_italic: bool,

    #[serde(default)]
    pub is_underline: bool,

    #[serde(default)]
    pub is_blink: bool,

    #[serde(default)]
    pub is_reverse: bool,

    #[serde(default)]
    pub is_hidden: bool,

    #[serde(default)]
    pub is_strikethrough: bool,

    #[serde(default)]
    pub prefix_with_reset: bool,
}

impl From<ConfigStyle> for Style {
    fn from(other: ConfigStyle) -> Self {
        Style(AnsiStyle {
            foreground: other.foreground,
            background: other.background,
            is_bold: other.is_bold,
            is_dimmed: other.is_dimmed,
            is_italic: other.is_italic,
            is_underline: other.is_underline,
            is_blink: other.is_blink,
            is_reverse: other.is_reverse,
            is_hidden: other.is_hidden,
            is_strikethrough: other.is_strikethrough,
            prefix_with_reset: other.prefix_with_reset,
        })
    }
}

#[derive(Debug, Default, Eq, PartialEq, Clone, Copy, Serialize, Deserialize)]
#[serde(from = "ConfigStyle")]
pub struct Style(AnsiStyle);

impl std::ops::Deref for Style {
    type Target = AnsiStyle;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::ops::DerefMut for Style {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

/// A string symbol with optional color
#[derive(Debug, Default, Clone, Serialize, Deserialize)]
pub struct Symbol {
    pub string: String,
    pub style: Option<Style>,
}

impl std::fmt::Display for Symbol {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> Result<(), std::fmt::Error> {
        self.style
            .unwrap_or_else(Default::default)
            .paint(&self.string)
            .fmt(f)
    }
}

/// A string symbol with additional 1D axis metadata
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Axis1DSymbol {
    name: Option<String>,
    distance: i32,
    string: String,
    style: Option<Style>,
}

/// A 1D input axis
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Axis1D {
    axis: AbsoluteAxisCode,
    style: Option<Style>,
    symbols: Vec<Axis1DSymbol>,
}

/// A string symbol with additional 2D axis metadata
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Axis2DSymbol {
    name: Option<String>,
    distance: i32,
    #[serde(rename = "arc")]
    arc: [f32; 2],
    string: String,
    style: Option<Style>,
}

/// A 2D input axis
#[derive(Debug, Clone, Serialize, Deserialize)]
struct Axis2D {
    #[serde(rename = "axis-x")]
    axis_x: AbsoluteAxisCode,
    #[serde(rename = "axis-y")]
    axis_y: AbsoluteAxisCode,
    style: Option<Style>,
    symbols: Vec<Axis2DSymbol>,
}

#[derive(Debug, Default, Clone, Serialize, Deserialize)]
struct AbsoluteAxes {
    #[serde(default, rename = "1d")]
    d1: HashMap<String, Axis1D>,
    #[serde(default, rename = "2d")]
    d2: HashMap<String, Axis2D>,
}

#[derive(Debug, Default, Clone)]
struct PressBuffer(Vec<(String, Input)>);

impl std::fmt::Display for PressBuffer {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let string = self
            .0
            .iter()
            .enumerate()
            .fold(String::new(), |acc, (i, (_, next))| {
                if i == 0 {
                    format!("{next:}")
                } else {
                    format!("{acc:} {next:}")
                }
            });

        write!(f, "{string}")
    }
}

impl DisplayWidth for PressBuffer {
    fn width(&self) -> Width {
        Width::Fixed(self.0.iter().enumerate().fold(0, |width, (i, (_, v))| {
            if i == 0 {
                v.symbol.string.width().unwrap_fixed()
            } else {
                width + 1 + v.symbol.string.width().unwrap_fixed()
            }
        }))
    }
}

impl<'a> DisplaySlice<'a> for PressBuffer {
    type Slice = Self;

    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        PressBuffer(
            self.0
                .iter()
                .map(|(k, v)| (k.clone(), v.clone()))
                .fold((true, 0, vec![]), |(first, width, mut acc), (k, v)| {
                    let delim_width = if first { 0 } else { 1 };
                    let sym_width = v.symbol.string.width().unwrap_fixed();
                    let width = width + delim_width;
                    if start <= width && width <= end {
                        acc.push((k, v));
                    }
                    (false, width + sym_width, acc)
                })
                .2,
        )
    }
}

impl std::ops::Deref for PressBuffer {
    type Target = Vec<(String, Input)>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::ops::DerefMut for PressBuffer {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

#[derive(Debug, Default, Clone)]
struct HeldBuffer(OrderMap<String, Input>);

impl std::fmt::Display for HeldBuffer {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        for (i, (_, next)) in self.0.iter().enumerate() {
            if i == 0 {
                write!(f, "{next:}")?;
            } else {
                write!(f, " + {next:}")?;
            }
        }
        Ok(())
    }
}

impl DisplayWidth for HeldBuffer {
    fn width(&self) -> Width {
        Width::Fixed(self.0.iter().enumerate().fold(0, |width, (i, (_, next))| {
            if i == 0 {
                width + next.symbol.string.width().unwrap_fixed()
            } else {
                width + 3 + next.symbol.string.width().unwrap_fixed()
            }
        }))
    }
}

impl<'a> DisplaySlice<'a> for HeldBuffer {
    type Slice = Self;
    fn slice(&'a self, start: usize, end: usize) -> Self::Slice {
        HeldBuffer(
            self.0
                .iter()
                .map(|(k, v)| (k.clone(), v.clone()))
                .fold(
                    (true, 0, OrderMap::default()),
                    |(first, width, mut acc), (k, v)| {
                        let delim_width = if first { 0 } else { 3 };
                        let sym_width = v.symbol.string.width().unwrap_fixed();
                        let width = width + delim_width;
                        if start <= width && width <= end {
                            acc.insert(k, v);
                        }
                        (false, width + sym_width, acc)
                    },
                )
                .2,
        )
    }
}

impl std::ops::Deref for HeldBuffer {
    type Target = OrderMap<String, Input>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::ops::DerefMut for HeldBuffer {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

#[derive(Debug, Default, Clone)]
struct CommandBuffer(Vec<Command>);

impl std::fmt::Display for CommandBuffer {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let width = f.width().unwrap_or_default();

        for entry in self.0.iter() {
            writeln!(f, "{:width$}", entry)?;
        }

        Ok(())
    }
}

impl DisplayWidth for CommandBuffer {
    fn width(&self) -> Width {
        Width::Fill
    }
}

impl std::ops::Deref for CommandBuffer {
    type Target = Vec<Command>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl std::ops::DerefMut for CommandBuffer {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

/// A device which produces input events
#[serde_with::serde_as]
#[derive(Debug, Clone, Deserialize)]
pub struct Device {
    pub path: PathBuf,

    pub name: Option<String>,
    pub icon: Option<Symbol>,
    pub style: Option<Style>,

    pub keymap: Option<Keymap>,

    #[serde(default)]
    pub modifiers: BTreeSet<String>,
    #[serde_as(as = "BTreeMap<GetNameFromName, _>")]
    #[serde(default)]
    pub keysyms: BTreeMap<Keysym, Symbol>,
    #[serde(default)]
    pub keycodes: BTreeMap<KeyCode, Symbol>,
    #[serde(default, rename = "absolute-axes")]
    pub absolute_axes: AbsoluteAxes,

    #[serde(default)]
    pub combinations: BTreeMap<String, Combination>,
    #[serde(default)]
    pub sequences: BTreeMap<String, Sequence>,

    pub press_buffer_len: Option<usize>,
    pub command_buffer_len: Option<usize>,
    pub debug: Option<bool>,

    #[serde(skip)]
    axes: HashMap<AbsoluteAxisCode, (i32, i32)>,
    #[serde(skip, default)]
    press_buffer: PressBuffer,
    #[serde(skip)]
    held_buffer: HeldBuffer,
    #[serde(skip)]
    command_buffer: CommandBuffer,
    #[serde(skip, default = "Device::default_wants_update")]
    wants_update: bool,
}

impl std::fmt::Display for Device {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let icon = self.icon();
        let style = icon.style.or(self.style).unwrap_or_else(Default::default);
        let width = f.width().unwrap_or_default();
        let height = f.precision().unwrap_or_default();

        // Draw separator
        writeln!(f, "{:width$}", bracket_fill!('╭', '─', '╮'))?;

        // Draw command buffer
        for j in (0..height - 8).into_iter().rev() {
            if let Some(command) = self.command_buffer.get(j) {
                writeln!(f, "{:width$}", bracket!("│ ", command, " │"))?;
            } else {
                writeln!(f, "{:width$}", bracket_fill!('│', ' ', '│'))?;
            }
        }

        // Draw separator
        writeln!(f, "{:width$}", bracket_fill!('├', '─', '┤'))?;

        // Draw held buffer
        writeln!(
            f,
            "{:width$}",
            bracket!(
                "│ ",
                cons!(
                    style.paint(&icon.string),
                    " : ",
                    trunc_r(
                        &self.held_buffer,
                        (width as isize - 7 - icon.string.width().unwrap_fixed() as isize).max(0)
                            as usize,
                        " …"
                    ),
                    fill(' ')
                ),
                " │"
            )
        )?;

        // Draw separator
        writeln!(f, "{:width$}", bracket_fill!('├', '─', '┤'))?;

        // Draw press buffer
        writeln!(
            f,
            "{:width$}",
            bracket!(
                "│ ",
                snoc!(
                    fill(' '),
                    trunc_l(
                        "… ",
                        (width as isize - 7 - icon.string.width().unwrap_fixed() as isize).max(0)
                            as usize,
                        &self.press_buffer,
                    ),
                    " 󰅁 ",
                    style.paint(&icon.string),
                ),
                " │"
            )
        )?;

        // Draw separator
        writeln!(f, "{:width$}", bracket_fill!('├', '─', '┤'))?;

        writeln!(
            f,
            "{:width$}",
            bracket!(
                "│ ",
                cons!(
                    trunc_r(
                        self.name.clone().unwrap_or_default(),
                        (width as isize - 4).max(0) as usize,
                        "…",
                    ),
                    fill(' ')
                ),
                " │"
            )
        )?;
        writeln!(f, "{:width$}", bracket_fill!('╰', '─', '╯'))?;

        Ok(())
    }
}

impl Device {
    fn default_press_buffer_len() -> usize {
        12
    }

    fn default_command_buffer_len() -> usize {
        12
    }

    fn default_wants_update() -> bool {
        true
    }

    fn push_command_buffer(&mut self, command: Command) {
        while self.command_buffer.len() >= self.command_buffer_len() {
            self.command_buffer.pop();
        }
        self.command_buffer.insert(0, command);
    }

    fn push_press_buffer(&mut self, key: String, input: Input) {
        while self.press_buffer.len() >= self.press_buffer_len() {
            self.press_buffer.remove(0);
        }
        self.press_buffer.push((key.clone(), input));
    }

    fn activate_input(&mut self, app: &mut App, key: String, input: Input) {
        self.push_press_buffer(key.clone(), input.clone());
        self.held_buffer.insert(key.clone(), input.clone());

        self.wants_update = true;

        if self.modifiers.contains(&input.symbol.string) {
            return;
        }

        let combos: BTreeSet<_> = self.combinations.values().cloned().collect();
        for combination in combos {
            for seq in combination.symbols.iter() {
                let mut iter = self.held_buffer.iter();
                let trigger = seq.iter().fold(true, |acc, v| {
                    if combination.ordered {
                        while let Some((_, next)) = iter.next() {
                            if next.symbol.string == *v && !next.consumed {
                                return acc & true;
                            }
                        }

                        false
                    } else {
                        acc && self
                            .held_buffer
                            .iter()
                            .find(|(_, w)| w.symbol.string == *v && !w.consumed)
                            .is_some()
                    }
                });

                if trigger {
                    seq.iter().for_each(|v| {
                        if let Some((_, w)) = self.held_buffer.iter_mut().find(|(_, w)| {
                            w.symbol.string == *v && !self.modifiers.contains(&w.symbol.string)
                        }) {
                            if combination.consume {
                                w.consumed = true;
                            }
                            w.style = combination.style.or(w.style);
                        }
                    });
                    combination.action.run(app);
                    self.push_command_buffer(Command {
                        name: combination.name,
                        delim: " + ".to_string(),
                        style: combination.style,
                        symbols: seq.clone(),
                    });
                    break;
                }
            }
        }

        let seqs: BTreeSet<_> = self.sequences.values().cloned().collect();
        for sequence in seqs {
            for seq in sequence.symbols.iter() {
                let mut inputs: Vec<_> = self.press_buffer.iter_mut().map(|(_, v)| v).collect();

                let start_idx = (inputs.len() as isize - seq.len() as isize).max(0) as usize;
                let slice = &mut inputs[start_idx..];

                let trigger = slice.iter().find(|w| w.consumed).is_none();

                let keys: Vec<_> = slice.iter().map(|v| v.symbol.string.as_str()).collect();

                if trigger && seq[..] == keys {
                    for v in slice.iter_mut() {
                        if sequence.consume {
                            v.consumed = true;
                        }
                        v.style = sequence.style.or(v.style);
                    }

                    sequence.action.run(app);
                    self.push_command_buffer(Command {
                        name: sequence.name,
                        delim: " ".to_string(),
                        style: sequence.style,
                        symbols: seq.clone(),
                    });
                    break;
                }
            }
        }
    }

    fn deactivate_input(&mut self, key: &str) {
        self.held_buffer.remove(key);
        self.wants_update = true;
    }

    fn update_axes_1d(&mut self, app: &mut App, code: AbsoluteAxisCode) {
        let style = self.style.or(app.config.styles.default);

        let (curr, prev) = *self.axes.entry(code).or_default();

        for (id, axis) in self.absolute_axes.d1.clone().into_iter() {
            let style = axis.style.or(style);

            if axis.axis != code {
                continue;
            }

            for symbol in axis.symbols.iter() {
                let style = symbol.style.or(style);

                if symbol.distance < 0 && curr <= symbol.distance && prev > symbol.distance {
                    self.activate_input(
                        app,
                        id.clone(),
                        Input::new(
                            Code::AbsoluteAxis(code),
                            Symbol {
                                string: symbol.string.clone(),
                                style,
                            },
                        ),
                    );
                } else if symbol.distance < 0 && curr > symbol.distance && prev <= symbol.distance {
                    self.deactivate_input(&id);
                } else if symbol.distance > 0 && curr >= symbol.distance && prev < symbol.distance {
                    self.activate_input(
                        app,
                        id.clone(),
                        Input::new(
                            Code::AbsoluteAxis(code),
                            Symbol {
                                string: symbol.string.clone(),
                                style,
                            },
                        ),
                    );
                } else if symbol.distance > 0 && curr < symbol.distance && prev >= symbol.distance {
                    self.deactivate_input(&id);
                }
            }
        }
    }

    fn update_axes_2d(&mut self, app: &mut App, code: AbsoluteAxisCode) {
        let style = self.style.or(app.config.styles.default);

        for (id, axis) in self.absolute_axes.d2.clone().into_iter() {
            let style = axis.style.or(style);

            if axis.axis_x != code && axis.axis_y != code {
                continue;
            }

            let (curr_x, _) = *self.axes.entry(axis.axis_x).or_default();
            let curr_x = curr_x as f32;

            let (curr_y, _) = *self.axes.entry(axis.axis_y).or_default();
            let curr_y = curr_y as f32;

            let curr_dist = curr_x.hypot(curr_y) as i32;

            let curr_ang = curr_y.atan2(curr_x).to_degrees();
            let curr_ang = if curr_ang < 0. {
                -(-180. - curr_ang) + 180.
            } else {
                curr_ang
            };

            let mut out = None;
            for symbol in axis.symbols.iter() {
                let style = symbol.style.or(style);

                if symbol.distance <= curr_dist
                    && ((symbol.arc[0] <= symbol.arc[1]
                        && symbol.arc[0] <= curr_ang
                        && curr_ang <= symbol.arc[1])
                        || (symbol.arc[0] > symbol.arc[1]
                            && (symbol.arc[0] < curr_ang || curr_ang < symbol.arc[1])))
                {
                    out = Some(Input::new(
                        Code::AbsoluteAxis(code),
                        Symbol {
                            string: symbol.string.clone(),
                            style: style,
                        },
                    ));
                    break;
                }
            }

            if let Some(out) = out {
                if let Some(held) = self.held_buffer.get(&id) {
                    if held.symbol.string != out.symbol.string {
                        self.activate_input(app, id.clone(), out);
                    }
                } else {
                    self.activate_input(app, id.clone(), out);
                }
            } else if self.held_buffer.get(&id).is_some() {
                self.deactivate_input(&id)
            }
        }
    }
}

impl Device {
    pub fn path(&self) -> &Path {
        &self.path
    }

    pub fn icon(&self) -> Symbol {
        self.icon.clone().unwrap_or_default()
    }

    pub fn keymap(&self) -> Keymap {
        self.keymap.clone().unwrap_or_default()
    }

    pub fn command_buffer_len(&self) -> usize {
        self.command_buffer_len.unwrap_or_else(Self::default_command_buffer_len)
    }

    pub fn press_buffer_len(&self) -> usize {
        self.command_buffer_len.unwrap_or_else(Self::default_press_buffer_len)
    }

    pub fn debug(&self) -> bool {
        self.debug.unwrap_or_default()
    }

    pub fn wants_update(&self) -> bool {
        self.wants_update
    }

    pub fn clear_wants_update(&mut self) {
        self.wants_update = false;
    }

    pub fn update_key(&mut self, app: &mut App, key_code: KeyCode, direction: i32) {
        let style = self.style.or(app.config.styles.default);

        let evdev_code = key_code.code();
        let xkb_code = (evdev_code + 8) as u32;
        let xkb_code: Keycode = xkb_code.into();

        let mut state = State::new(&self.keymap());
        for input in self.held_buffer.values() {
            if let Code::Key(code) = input.code {
                state.update_key(code, KeyDirection::Down);
            }
        }
        let keysym = state.key_get_one_sym(xkb_code);

        let id = format!("{key_code:?}");
        let input = if let Keysym::NoSymbol = keysym {
            let name = format!("{key_code:?}");
            Input::new(
                Code::Key(xkb_code),
                self.keycodes.get(&key_code).cloned().unwrap_or(Symbol {
                    string: name,
                    style,
                }),
            )
        } else {
            Input::new(
                Code::Key(xkb_code),
                self.keysyms
                    .get(&keysym)
                    .cloned()
                    .unwrap_or_else(|| Symbol {
                        string: if self.debug() {
                            keysym_get_name(keysym)
                        } else {
                            keysym_to_utf8(keysym)
                        },
                        style,
                    }),
            )
        };

        match direction {
            0 => self.deactivate_input(&id),
            1 => self.activate_input(app, id, input),
            2 => self.activate_input(app, id, input),
            _ => (),
        }
    }

    pub fn update_axis(&mut self, app: &mut App, code: AbsoluteAxisCode, value: i32) {
        let (curr, _) = self.axes.entry(code).or_default();
        *curr = value;
        self.update_axes_1d(app, code);
        self.update_axes_2d(app, code);
        let (_, prev) = self.axes.entry(code).or_default();
        *prev = value;
    }
}

pub trait Concat<T> {
    type Result;

    fn concat(self, other: T) -> Self::Result;
}

impl Concat<Device> for Device {
    type Result = Self;

    fn concat(self, other: Device) -> Self::Result {
        assert!(
            self.path == other.path,
            "Cannot concatenate devices with mismatched paths"
        );

        Device {
            path: other.path,
            name: other.name,
            icon: self.icon.concat(other.icon),
            style: self.style.concat(other.style),
            keymap: self.keymap.concat(other.keymap),
            modifiers: self.modifiers.concat(other.modifiers),
            keysyms: self.keysyms.concat(other.keysyms),
            keycodes: self.keycodes.concat(other.keycodes),
            absolute_axes: self.absolute_axes.concat(other.absolute_axes),
            combinations: self.combinations.concat(other.combinations),
            sequences: self.sequences.concat(other.sequences),
            press_buffer_len: self.press_buffer_len.concat(other.press_buffer_len),
            command_buffer_len: self.command_buffer_len.concat(other.command_buffer_len),
            debug: self.debug.concat(other.debug),
            axes: self.axes.concat(other.axes),
            press_buffer: other.press_buffer,
            held_buffer: other.held_buffer,
            command_buffer: other.command_buffer,
            wants_update: other.wants_update,
        }
    }
}

impl<T> Concat<Self> for Option<T>
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        self.or(other)
    }
}

impl<T> Concat<Self> for Vec<T>
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        self.into_iter().chain(other.into_iter()).collect()
    }
}

impl<T> Concat<Self> for BTreeSet<T>
where
    T: Ord,
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        self.into_iter().chain(other.into_iter()).collect()
    }
}

impl<K, V> Concat<Self> for BTreeMap<K, V>
where
    K: Ord,
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        self.into_iter().chain(other.into_iter()).collect()
    }
}

impl<K, V> Concat<Self> for HashMap<K, V>
where
    K: std::hash::Hash + Eq,
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        self.into_iter().chain(other.into_iter()).collect()
    }
}

impl Concat<Self> for AbsoluteAxes
{
    type Result = Self;

    fn concat(self, other: Self) -> Self::Result {
        AbsoluteAxes {
            d1: self.d1.concat(other.d1),
            d2: self.d2.concat(other.d2),
        }
    }
}

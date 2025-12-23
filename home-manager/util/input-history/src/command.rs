use serde::{Deserialize, Serialize};
use std::collections::BTreeSet;

use crate::{app::App, device::Style, ui::{DisplayWidth, Width}};

/// An action to perform as the result of a command
#[derive(Debug, Default, Copy, Clone, Serialize, Deserialize)]
pub enum Action {
    #[default]
    None,
    Quit,
}

impl Action {
    pub fn run(self, app: &mut App) {
        match self {
            Action::None => (),
            Action::Quit => app.quit(),
        }
    }
}

/// An optionally-ordered combination of symbols
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Combination {
    pub name: String,
    pub style: Option<Style>,
    pub symbols: Vec<Vec<String>>,
    #[serde(default = "Combination::default_ordered")]
    pub ordered: bool,
    #[serde(default = "Combination::default_consume")]
    pub consume: bool,
    #[serde(default)]
    pub action: Action,
}

impl Combination {
    fn default_ordered() -> bool {
        true
    }

    fn default_consume() -> bool {
        true
    }
}

impl PartialEq for Combination {
    fn eq(&self, other: &Combination) -> bool {
        self.symbols == other.symbols
    }
}

impl Eq for Combination {}

impl PartialOrd for Combination {
    fn partial_cmp(&self, other: &Combination) -> Option<std::cmp::Ordering> {
        other.symbols.len().partial_cmp(&self.symbols.len())
    }
}

impl Ord for Combination {
    fn cmp(&self, other: &Combination) -> std::cmp::Ordering {
        other.symbols.len().cmp(&self.symbols.len())
    }
}
impl DisplayWidth for Combination {
    fn width(&self) -> Width {
        Width::Fill
    }
}

/// An ordered sequence of symbols
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Sequence {
    pub name: String,
    pub style: Option<Style>,
    pub symbols: Vec<Vec<String>>,
    #[serde(default)]
    pub action: Action,
    #[serde(default = "Sequence::default_consume")]
    pub consume: bool,
}

impl Sequence {
    fn default_consume() -> bool {
        true
    }
}

impl PartialEq for Sequence {
    fn eq(&self, other: &Sequence) -> bool {
        self.symbols == other.symbols
    }
}

impl Eq for Sequence {}

impl PartialOrd for Sequence {
    fn partial_cmp(&self, other: &Sequence) -> Option<std::cmp::Ordering> {
        other.symbols.len().partial_cmp(&self.symbols.len())
    }
}

impl Ord for Sequence {
    fn cmp(&self, other: &Sequence) -> std::cmp::Ordering {
        other.symbols.len().cmp(&self.symbols.len())
    }
}

impl DisplayWidth for Sequence {
    fn width(&self) -> Width {
        Width::Fill
    }
}

/// A combination or sequence or symbols
#[derive(Debug, Clone)]
pub struct Command {
    pub name: String,
    pub style: Option<Style>,
    pub delim: String,
    pub symbols: Vec<String>,
}

impl DisplayWidth for Command {
    fn width(&self) -> Width {
        Width::Fill
    }
}

impl std::fmt::Display for Command {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let width = f.width().unwrap_or_default();

        let name = self.name();

        let seq_string = self
            .symbols()
            .iter()
            .fold(String::new(), |acc, next| {
                if acc.is_empty() {
                    next.clone()
                } else {
                    acc + &self.delim + next
                }
            });

        let seq_len = utf8_slice::len(&seq_string);
        let name_len = utf8_slice::len(&name);

        let half_width = width / 2;

        let seq_width = seq_len.min(half_width);
        let name_width = name_len.min(half_width);
        let pad_width = width - seq_width - name_width;

        let seq_trunc = seq_width < seq_len;
        let name_trunc = name_width < name_len;

        let pad_width = if seq_trunc { pad_width + 1 } else { pad_width };
        let seq_width = if seq_trunc { seq_width.saturating_sub(2) } else { seq_width };
        let name_width = if name_trunc {
            name_width.saturating_sub(1)
        } else {
            name_width
        };

        write!(
            f,
            "{}",
            self.style().paint(format!(
                "{}{}{: ^pad_width$}{}{}",
                utf8_slice::slice(&seq_string, 0, seq_width),
                if seq_trunc { "…" } else { "" },
                "",
                if name_trunc { "…" } else { "" },
                utf8_slice::slice(&name, name.len() - name_width, name.len())
            ))
        )
    }
}

impl Command {
    pub fn name(&self) -> &str {
        &self.name
    }

    pub fn style(&self) -> Style {
        self.style.unwrap_or_default()
    }

    pub fn symbols(&self) -> &[String] {
        &self.symbols
    }
}

use crate::device::Style;
use crate::ui::{Height, Width};
use serde::Deserialize;

const DEFAULT_CONFIG: &str = include_str!("../config/input-history.toml");

#[derive(Debug, Default, Copy, Clone, Deserialize, PartialEq, Eq)]
pub enum LayoutDirection {
    #[default]
    TopBottom,
    BottomTop,
}

#[derive(Debug, Default, Copy, Clone, Deserialize, PartialEq, Eq)]
pub enum HorizontalEdge {
    #[default]
    Left,
    Right,
}

#[derive(Debug, Default, Copy, Clone, Deserialize, PartialEq, Eq)]
pub enum VerticalEdge {
    Top,
    #[default]
    Bottom,
}

#[derive(Debug, Default, Clone, Deserialize)]
pub struct Align {
    #[serde(default)]
    pub horizontal: HorizontalEdge,
    #[serde(default)]
    pub vertical: VerticalEdge,
}

#[derive(Debug, Default, Clone, Deserialize)]
pub struct Layout {
    pub align: Align,
    pub width: Option<Width>,
    pub height: Option<Height>,
    #[serde(default)]
    pub direction: LayoutDirection,
}

#[derive(Debug, Default, Clone, Deserialize)]
pub struct Styles {
    pub default: Option<Style>,
}

#[derive(Clone, Deserialize)]
pub struct Config {
    #[serde(default)]
    pub styles: Styles,
    #[serde(default)]
    pub layout: Layout,
}

impl Config {
    pub fn default() -> Result<Self, toml::de::Error> {
        toml::from_str(DEFAULT_CONFIG)
    }
}

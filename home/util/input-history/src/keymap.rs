use serde::{Deserialize, Serialize};
use xkbcommon::xkb::{
    Context, Keymap as XkbKeymap, CONTEXT_NO_FLAGS,
    KEYMAP_COMPILE_NO_FLAGS,
};

#[derive(Debug, Clone, Serialize, Deserialize)]
struct KeymapConfig {
    #[serde(default = "KeymapConfig::default_rules")]
    rules: String,
    #[serde(default = "KeymapConfig::default_layout")]
    layout: String,
    #[serde(default = "KeymapConfig::default_model")]
    model: String,
    #[serde(default = "KeymapConfig::default_variant")]
    variant: String,
}

impl KeymapConfig {
    fn default_rules() -> String {
        "".into()
    }

    fn default_layout() -> String {
        "us".into()
    }

    fn default_model() -> String {
        "pc105".into()
    }

    fn default_variant() -> String {
        "".into()
    }
}

impl Default for KeymapConfig {
    fn default() -> Self {
        KeymapConfig {
            rules: Self::default_rules(),
            layout: Self::default_layout(),
            model: Self::default_model(),
            variant: Self::default_variant(),
        }
    }
}

impl Into<XkbKeymap> for KeymapConfig {
    fn into(self) -> XkbKeymap {
        XkbKeymap::new_from_names(
            &Context::new(CONTEXT_NO_FLAGS),
            &self.rules,
            &self.model,
            &self.layout,
            &self.variant,
            None,
            KEYMAP_COMPILE_NO_FLAGS,
        )
        .expect("Failed to create keymap")
    }
}


#[derive(Clone, Deserialize)]
#[serde(from = "KeymapConfig")]
pub struct Keymap(XkbKeymap);

impl std::fmt::Debug for Keymap {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        f.write_str("Keymap")
    }
}

impl Default for Keymap {
    fn default() -> Self {
        Keymap(KeymapConfig::default().into())
    }
}

impl std::ops::Deref for Keymap {
    type Target = XkbKeymap;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<KeymapConfig> for Keymap {
    fn from(config: KeymapConfig) -> Self {
        Keymap(config.into())
    }
}


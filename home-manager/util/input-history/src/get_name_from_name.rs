use serde::de::Visitor;
use serde_with::{DeserializeAs, SerializeAs};
use xkbcommon::xkb::{Keysym, keysym_from_name, keysym_get_name};

pub struct GetNameFromName;

impl SerializeAs<Keysym> for GetNameFromName {
    fn serialize_as<S>(source: &Keysym, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer {
        serializer.serialize_str(&keysym_get_name(*source))
    }
}

impl<'de> Visitor<'de> for GetNameFromName {
    type Value = Keysym;

    fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(formatter, "a string representing a Keysym")
    }

    fn visit_str<E>(self, v: &str) -> Result<Self::Value, E>
    where
        E: serde::de::Error,
    {
        Ok(keysym_from_name(&v, 0))
    }

    fn visit_borrowed_str<E>(self, v: &'de str) -> Result<Self::Value, E>
    where
        E: serde::de::Error,
    {
        Ok(keysym_from_name(&v, 0))
    }

    fn visit_string<E>(self, v: String) -> Result<Self::Value, E>
    where
        E: serde::de::Error,
    {
        Ok(keysym_from_name(&v, 0))
    }
}

impl<'de> DeserializeAs<'de, Keysym> for GetNameFromName {
    fn deserialize_as<D>(deserializer: D) -> Result<Keysym, D::Error>
    where
        D: serde::Deserializer<'de> {
        deserializer.deserialize_str(GetNameFromName)
    }
}

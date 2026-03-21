{ pkgs, ... }:

{
  # Use GTK3 for color / emoji / file pickers
  environment.systemPackages = [
    pkgs.gtk3
  ];

  # Override the GSettings schema dir to point at gtk3
  # Works around https://github.com/NixOS/nixpkgs/issues/154150
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR =
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };
}

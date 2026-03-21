{ lib, ... }:

{
  # Enable Qt and set the GTK3 theme
  qt = {
    enable = true;
    style.name = lib.mkForce "gtk3";
    platformTheme.name = lib.mkForce "gtk3";
  };
}

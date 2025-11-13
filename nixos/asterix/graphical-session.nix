{ pkgs, ... }:

{
  # Use greetd as our login manager
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/hyprland";
        user = "lander";
      };
      default_session = initial_session;
    };
  };

  # Configure graphical services
  services.xserver = {
    enable = true;

    # Keymap
    xkb = {
      layout = "us";
      variant = "";
    };

    # Disable default GDM displaymanager
    displayManager.gdm.enable = false;
  };

  # Use hyprland as our compositor
  programs.hyprland.enable = true;

  # Enable Ozone Wayland support in Chrome and Electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

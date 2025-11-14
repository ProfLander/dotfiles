{ pkgs, inputs, ... }:

let
  niri = inputs.niri;
in {
  # Use uswm to wrap wayland compositors into systemd units
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "${pkgs.hyprland}/bin/Hyprland";
      };

      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "${pkgs.niri}/bin/niri-session";
      };
    };
  };

  environment.loginShellInit = ''
    if uwsm check may-start && uwsm select; then
      exec uwsm start default
    fi
  '';

  # Use hyprland as the main compositor
  programs.hyprland.enable = true;

  # Try out niri
  imports = [ niri.nixosModules.niri ];
  nixpkgs.overlays = [ niri.overlays.niri ];
  programs.niri.enable = true;

  # Enable Ozone Wayland support in Chrome and Electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

{ pkgs, inputs, ... }:

let
  niri-flake = inputs.niri-flake;
  niri = inputs.niri.packages.${pkgs.system}.default;
in {
  # Use uswm to wrap wayland compositors into systemd units
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "${pkgs.niri}/bin/niri-session";
      };
    };
  };

  environment.loginShellInit = ''
    if uwsm check may-start; then
      exec uwsm start default
    fi
  '';

  # Use niri as our compositor
  imports = [ niri-flake.nixosModules.niri ];
  nixpkgs.overlays = [ niri-flake.overlays.niri ];
  programs.niri.enable = true;
  programs.niri.package = niri;
}

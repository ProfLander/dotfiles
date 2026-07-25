{ pkgs, ... }:

{
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
  programs.niri.enable = true;
}

{ pkgs, ... }:
{
  systemd.user.services.main-text-editor = pkgs.graphical-program {
    desc = "Text editor";
    exec-start = ''
      ${pkgs.alacritty}/bin/alacritty --class main-text-editor
    '';
  };
}

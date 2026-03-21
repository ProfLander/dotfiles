{ pkgs, ... }:

{
  home.packages = [
    pkgs.swaybg
  ];

  systemd.user.services.swaybg = pkgs.graphical-program {
    desc = "Desktop wallpaper";
    exec-start = ''
      ${pkgs.swaybg}/bin/swaybg \
      -i ${./wallpaper-dark-blur-abstract.jpg} \
      -m fill'';
  };
}

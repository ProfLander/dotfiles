{ config, pkgs, ... }:

{
  home.packages = [
      pkgs.broot
  ];

  home.file."${config.xdg.configHome}/broot/skins/dracula.hjson" = {
    source = ./dracula.hjson;
  };

  home.file."${config.xdg.configHome}/broot/conf.hjson" = {
    source = ./conf.hjson;
  };

  home.file."${config.xdg.configHome}/broot/verbs.hjson" = {
    source = ./verbs.hjson;
  };
}

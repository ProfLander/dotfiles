{ config, ... }:
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/xdg/desktop";
    documents = "${config.home.homeDirectory}/xdg/documents";
    download = "${config.home.homeDirectory}/xdg/download";
    music = "${config.home.homeDirectory}/xdg/music";
    pictures = "${config.home.homeDirectory}/xdg/pictures";
    publicShare = "${config.home.homeDirectory}/xdg/public";
    templates = "${config.home.homeDirectory}/xdg/templates";
    videos = "${config.home.homeDirectory}/xdg/videos";
  };
}

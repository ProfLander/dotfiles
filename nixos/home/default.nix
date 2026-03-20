{
  home.username = "lander";
  home.homeDirectory = "/home/lander";

  imports = [
     ../../home-manager/lander/cli/default.nix
  #  ../../home-manager/lander/desktop/default.nix
     ../../home-manager/lander/gaming/default.nix
     ../../home-manager/lander/media/default.nix
     ../../home-manager/lander/toolchains/default.nix

     ../../home-manager/lander/dconf.nix
     ../../home-manager/lander/garbage-collection.nix
     ../../home-manager/lander/session-variables.nix
  ];

  home.stateVersion = "25.05";
}

{
  home.username = "lander";
  home.homeDirectory = "/home/lander";

  imports = [
  #  ./cli/default.nix
  #  ./desktop/default.nix
     ./gaming/default.nix
     ./media/default.nix
     ./toolchains/default.nix

     ./dconf.nix
     ./garbage-collection.nix
     ./session-variables.nix
  ];

  home.stateVersion = "25.05";
}

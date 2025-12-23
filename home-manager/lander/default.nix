{
  home.username = "lander";
  home.homeDirectory = "/home/lander";

  imports = [
    ./cli/default.nix
    ./desktop/default.nix
    ./gaming/default.nix
    ./media/default.nix
    ./toolchains/default.nix

    ./dconf.nix
    ./rgb.nix
    ./session-variables.nix
  ];
}

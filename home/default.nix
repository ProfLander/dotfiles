{ lib, stdenv, secrets, ... }:

{
  home.username = "lander";
  home.homeDirectory = "/home/lander";

  imports = [
    ./lander/cli/default.nix
    ./lander/desktop/default.nix
    ./lander/gaming/default.nix
    ./lander/media/default.nix
    ./lander/toolchains/default.nix

    ./lander/dconf.nix
    ./lander/garbage-collection.nix
    ./lander/session-variables.nix

    ../hardware/calliope/home.nix
  ];

  home.file.".password-store".source = secrets.password-store {
    inherit lib;
    inherit stdenv;
  };

  home.stateVersion = "25.05";
}

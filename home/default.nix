{
  imports = [
    ./minimal.nix

    ./lander/cli/default.nix
    ./lander/desktop/default.nix
    ./lander/gaming/default.nix
    ./lander/media/default.nix
    ./lander/toolchains/default.nix

    ./lander/dconf.nix
    ./lander/garbage-collection.nix
    ./lander/session-variables.nix
    ./lander/password-store.nix

    ../hardware/calliope/home.nix
  ];
}

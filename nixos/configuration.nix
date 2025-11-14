{
  imports =
    [
      ./asterix/default.nix
      ./hardware/artemis/default.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}

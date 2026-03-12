{
  imports = [
    ./boot.nix
    ./cpu.nix
    ./disks.nix
    ./firmware.nix
    ./gpu.nix
    ./monitors.nix
    ./network.nix
    ./users/lander.nix
    ../../asterix/common/default.nix
    ../../asterix/desktop/default.nix
    ../../asterix/users/lander.nix
  ];

  system.stateVersion = "25.05";
}

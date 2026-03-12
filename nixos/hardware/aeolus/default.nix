{
  imports = [
    ./boot.nix
    ./cpu.nix
    ./disks.nix
    ./firmware.nix
    ./network.nix
    ./security.nix
    ./ssh.nix
    ../../asterix/common/default.nix
    ../../asterix/users/lander.nix
  ];

  system.stateVersion = "25.11";
}

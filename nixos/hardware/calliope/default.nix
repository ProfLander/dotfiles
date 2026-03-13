{
  imports = [
    ./boot.nix
    ./disks.nix
    ./network.nix
    ../common/firmware.nix
    ../common/x86_64.nix
    ../common/cpu-amd.nix
    ../common/gpu-amd.nix
    ../../software/common/default.nix
    ../../software/desktop/default.nix
    ../../software/users/lander-desktop.nix
  ];

  system.stateVersion = "25.11";
}

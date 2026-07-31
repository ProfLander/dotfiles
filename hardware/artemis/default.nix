{
  imports = [
    ./boot.nix
    ./disks.nix
    ./monitors.nix
    ./network.nix
    ./syncthing.nix
    ../common/firmware.nix
    ../common/x86_64.nix
    ../common/cpu-amd.nix
    ../common/gpu/default.nix
    ../common/gpu/amd.nix
    ../../software/allow-unfree.nix
    ../../software/common/default.nix
    ../../software/desktop/default.nix
  ];

  system.stateVersion = "25.05";
}

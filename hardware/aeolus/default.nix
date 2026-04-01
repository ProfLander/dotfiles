{
  imports = [
    ./boot.nix
    ./cron/default.nix
    ./disks.nix
    ./network.nix
    ./nginx.nix
    ./security.nix
    ./transmission.nix
    ../common/firmware.nix
    ../common/x86_64.nix
    ../common/cpu-intel.nix
    ../../software/common/default.nix
  ];

  system.stateVersion = "25.11";
}

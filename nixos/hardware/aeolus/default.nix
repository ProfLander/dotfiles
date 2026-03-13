{
  imports = [
    ./boot.nix
    ./cron/default.nix
    ./disks.nix
    ./network.nix
    ./security.nix
    ./ssh.nix
    ../common/firmware.nix
    ../common/x86_64.nix
    ../common/cpu-intel.nix
    ../../software/common/default.nix
    ../../software/users/lander.nix
  ];

  system.stateVersion = "25.11";
}

{
  imports = [
    ./boot.nix
    ./disks.nix
    ./network.nix
    ./firmware.nix
    ../common/aarch64.nix
    ../../software/common/garbage-collection.nix
    ../../software/common/locale.nix
    ../../software/common/network.nix
    ../../software/common/nix.nix
    ../../software/common/power.nix
    ../../software/common/shell.nix
    ../../software/common/ssh.nix
    ../../software/common/zram.nix
    ../../software/common/boot/initrd.nix
    ../../software/common/boot/tmp.nix
  ];

  system.stateVersion = "25.11";
}

{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./disks.nix
    ./network.nix
    ./firmware.nix
    ../common/aarch64.nix
    ../common/gpu/default.nix
    ../../software/common/dbus.nix
    ../../software/common/disks.nix
    ../../software/common/garbage-collection.nix
    ../../software/common/irq.nix
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

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  system.stateVersion = "25.11";
}

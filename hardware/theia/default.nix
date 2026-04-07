{ pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./disks.nix
    ./firmware.nix
    ./home-assistant.nix
    ./network.nix
    ./pi-hole.nix

    ../common/aarch64.nix
    ../common/gpu/default.nix

    ../../software/common/default.nix

    ../../software/common/boot/initrd.nix
    ../../software/common/boot/tmp.nix
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  system.stateVersion = "25.11";
}

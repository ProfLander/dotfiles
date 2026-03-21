{
  swapDevices = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9322ad15-d03c-4ef2-a5de-48a2b00d3594";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/78F7-1A7B";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
}

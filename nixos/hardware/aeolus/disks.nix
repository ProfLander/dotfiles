{
  swapDevices = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab6eae60-ccc5-44ea-a3ea-366a3a53edac";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3A09-43E6";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/scratch" = {
    device = "/dev/disk/by-uuid/bef2b4b6-e809-4b26-9464-fb93f8687b67";
    fsType = "btrfs";
  };
}

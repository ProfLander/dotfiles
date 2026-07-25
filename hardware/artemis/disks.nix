{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/847eb04d-4acf-4f1c-88d5-701b6a62019c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0F22-6821";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/1d53e828-6d5b-4b97-8627-84e4adb31391";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/c4138465-5c7b-4164-9404-90a1ceef0d77";
    fsType = "ext4";
  };

  fileSystems."/mnt/scratch" = {
    device = "/dev/disk/by-uuid/9bec8d1d-a0d8-4f88-b2dc-566dbb479b7c";
    fsType = "btrfs";
  };

  fileSystems."/mnt/projects" = {
    device = "/dev/disk/by-uuid/9c0d33e7-4695-4a4a-a1d3-3724a76f8e91";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096;
    }
  ];
}

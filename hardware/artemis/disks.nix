{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ea94bb60-90f3-4218-9c1b-4a97361a149e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F2F8-990D";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/acb2cd81-1ba0-4240-9cf8-f119fe1e96a1";
    fsType = "ext4";
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/1d53e828-6d5b-4b97-8627-84e4adb31391";
    fsType = "ext4";
  };

  fileSystems."/mnt/scratch" = {
    device = "/dev/disk/by-uuid/9b77fd54-622e-4a81-9aea-bb0d4d29ed11";
    fsType = "ext4";
  };

  fileSystems."/mnt/projects" = {
    device = "/dev/disk/by-uuid/9c0d33e7-4695-4a4a-a1d3-3724a76f8e91";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/c4138465-5c7b-4164-9404-90a1ceef0d77";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096;
    }
  ];
}

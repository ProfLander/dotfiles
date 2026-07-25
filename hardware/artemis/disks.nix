{
  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/backup" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };

  fileSystems."/mnt/scratch" = {
    device = "/dev/sdc1";
    fsType = "btrfs";
  };

  fileSystems."/mnt/projects" = {
    device = "/dev/sdd1";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096;
    }
  ];
}

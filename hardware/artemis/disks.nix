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
    device = "/dev/disk/by-uuid/9ed884cc-c050-49ca-8d1c-62338eaa1725";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/9af2451d-0950-424b-9111-e55ca476a039";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/9bec8d1d-a0d8-4f88-b2dc-566dbb479b7c";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/retro" = {
    device = "/dev/disk/by-uuid/86ff0ea1-54e1-4b8c-8fd0-e262cc2cc366";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096;
    }
  ];
}

{
  ### NixOS power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 1;
      # USB devices to exclude
      USB_DENYLIST = "3297:c6cf 5043:5c47";
    };
  };

  hardware.system76.power-daemon.enable = true;

  services.lact.enable = true;
  hardware.amdgpu.overdrive.enable = true;
}

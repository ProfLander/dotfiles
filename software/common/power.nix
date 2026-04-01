{
  ### NixOS power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  services.tlp = {
    enable = true;
    settings.USB_AUTOSUSPEND = 1;
  };

  hardware.system76.power-daemon.enable = true;

  services.lact.enable = true;
}

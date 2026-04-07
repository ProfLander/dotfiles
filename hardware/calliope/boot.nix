{
  imports = [
    ../../software/common/boot/default.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "ehci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];

  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # Allow cross-compilation to AArch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}

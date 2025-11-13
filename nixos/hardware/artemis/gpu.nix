{
  boot.initrd.availableKernelModules = [
    "amdgpu"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}

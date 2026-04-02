{
  boot.initrd.kernelModules = [
    "amdgpu"
  ];

  hardware.graphics.enable32Bit = true;
  hardware.amdgpu.overdrive.enable = true;
}

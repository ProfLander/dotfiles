{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.lm_sensors
    pkgs.rocmPackages.rocm-smi
    pkgs.rocmPackages.amdsmi
    pkgs.neofetch
    (pkgs.btop.override { rocmSupport = true; })
  ];
}

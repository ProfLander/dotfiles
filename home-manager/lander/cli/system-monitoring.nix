{ pkgs, ... }:

{
  home.packages = [
    pkgs.lm_sensors
    pkgs.rocmPackages.rocm-smi
    pkgs.neofetch
    (pkgs.btop.override { rocmSupport = true; })
  ];
}

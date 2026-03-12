{ pkgs, ... }:

{
  home.packages = [
    pkgs.lm_sensors
    pkgs.rocmPackages.rocm-smi
    pkgs.fastfetch
    (pkgs.btop.override { rocmSupport = true; })
  ];
}

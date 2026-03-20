{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.lm_sensors
    pkgs.rocmPackages.rocm-smi
    pkgs.fastfetch
    (pkgs.btop.override { rocmSupport = true; })
  ];

  home.file."${config.xdg.configHome}/btop/btop.conf".source = ./btop.conf;
}

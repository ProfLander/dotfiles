{ config, util-niri, ... }:

{
  imports = [
    ../../home/default.nix
  ];

  home.file.".config/niri/config.kdl" = {
    text = (util-niri.niri-config config) + ''
      output "GIGA-BYTE TECHNOLOGY CO., LTD. Gigabyte M32U 22131B002818" {
          scale 1.500000
          focus-at-startup
          transform "normal"
          position x=0 y=0
          mode "3840x2160@143.999"
          variable-refresh-rate on-demand=false
      }

      output "Sony SONY TV 0x01010101" {
          transform "normal"
          position x=-1920 y=${(toString (builtins.floor (((2160 / 1.5) - 1080) / 2)))}
          mode "1920x1080@60"
      }
    '';
  };
}

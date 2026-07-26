{ config, util-niri, secrets, ... }:

{
  imports = [
    ../../home/default.nix
  ];

  home.file.".ssh/id_ed25519".text = secrets.users.lander.calliope.private;

  home.file.".config/niri/config.kdl" = {
    text = (util-niri.niri-config config) + ''
      output "Dell Inc. DELL U2412M 0FFXD47C5YML" {
          transform "normal"
          position x=2560 y=120
          mode "1920x1200@59.950000"
      }

      output "GIGA-BYTE TECHNOLOGY CO., LTD. Gigabyte M32U 22131B002818" {
          scale 1.500000
          focus-at-startup
          transform "normal"
          position x=0 y=0
          mode "3840x2160@59.997000"
          variable-refresh-rate on-demand=false
      }

      output "ViewSonic Corporation XG270QG #ASO0fiw/4MTd" {
          transform "normal"
          position x=-2560 y=0
          mode "2560x1440@59.951000"
          variable-refresh-rate on-demand=false
      }
    '';
  };
}

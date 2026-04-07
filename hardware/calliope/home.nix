{ secrets, ... }:

{
  home.file.".ssh/id_ed25519".text = secrets.users.lander.calliope.private;

  programs.niri.settings = {
    outputs = {
      "GIGA-BYTE TECHNOLOGY CO., LTD. Gigabyte M32U 22131B002818" = {
        enable = true;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 59.997;
        };
        variable-refresh-rate = true;
        scale = 1.5;
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
      };

      "ViewSonic Corporation XG270QG #ASO0fiw/4MTd" = {
        enable = true;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 59.951;
        };
        variable-refresh-rate = true;
        position = {
          x = -2560;
          y = builtins.floor (((2160 / 1.5) - 1440) / 2);
        };
      };

      "Dell Inc. DELL U2412M 0FFXD47C5YML" = {
        enable = true;
        mode = {
          width = 1920;
          height = 1200;
          refresh = 59.95;
        };
        position = {
          x = builtins.ceil (3840 / 1.5);
          y = builtins.floor (((2160 / 1.5) - 1200) / 2);
        };
      };
    };
  };
}

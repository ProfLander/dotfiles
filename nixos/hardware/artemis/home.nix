{
  programs.niri.settings = {
    outputs = {
       "GIGA-BYTE TECHNOLOGY CO., LTD. Gigabyte M32U 22131B002818" = {
        enable = true;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 143.999;
        };
        variable-refresh-rate = true;
        scale = 1.5;
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
      };
      "Sony SONY TV 0x01010101" = {
        enable = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 0 - 2560 - 1920;
          y = builtins.floor (((2160 / 1.5) - 1080) / 2);
        };
      };
    };
  };
}

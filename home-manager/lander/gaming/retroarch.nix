{
  programs.retroarch = {
    enable = true;
    # List desired cores here (e.g., snes9x, dolphin, genesis-plus-gx)
    cores = {
      beetle-psx.enable = true;
      beetle-saturn.enable = true;
    };
    # Optional: Configure basic settings
    settings = {
      # video_driver = "glcore";
      # menu_driver = "ozone";
    };
  };
}

{
  programs.alacritty = {
    enable = true;
    theme = "dracula";
    settings = {
      window = {
        opacity = 0.6;
        padding = {
          x = 8;
          y = 0;
        };
      };

      font = {
        size = 12;

        normal = {
          family = "FiraCode Nerd Font";
        };

        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };

        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };

  home.sessionVariables = {
    TERM = "alacritty";
  };
}

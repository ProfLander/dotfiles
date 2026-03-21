{ pkgs, ... }:
{
  programs.neovide = {
    enable = true;
    settings = {
      # see below for the default platform specific location
      #backtraces_path = "/path/to/neovide_backtraces.log"
      fork = false;
      frame = "full";
      idle = true;
      # Example path. Default icon is bundled. Use .icns on macOS.
      #icon = "/full/path/to/neovide.ico"
      maximized = false;
      mouse-cursor-icon = "arrow";
      # in reality found dynamically on $PATH if unset
      #neovim-bin = "/usr/bin/nvim"
      multigrid = true;
      # platform-specific: false (Linux/macOS) or true (Windows)
      #srgb = false
      tabs = false;
      title-hidden = false;
      vsync = true;
      wsl = false;

      font = {
        normal = [ "FiraCode Nerd Font" ];
        size = 12.0;
      };

      box-drawing = {
        # "font-glyph", "native" or "selected-native"
        mode = "font-glyph";
      };

      box-drawing = {
        sizes = {
          # Thin and thick values respectively, for all sizes
          default = [
            2
            4
          ];
        };
      };
    };
  };

  home.packages = [
    pkgs.run-neovide
  ];

  home.sessionVariables = {
    VISUAL = "$EDITOR";
  };

  systemd.user.services.neovide = pkgs.graphical-program {
    desc = "Text editor";
    exec-start = ''
      ${pkgs.neovide}/bin/neovide \
        --server localhost:9034 \
        --wayland_app_id main-text-editor'';
  };
}

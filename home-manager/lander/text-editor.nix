{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  programs.neovim = {
    enable = true;
    #defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      " Enable line numbers
      set number

      " Always show sign column to prevent jarring resizes
      set signcolumn=yes

      " Scroll one line at a time
      set mousescroll=ver:1,hor:1

      " Neovide background opacity
      let g:neovide_normal_opacity=0.6

      " More responsive neovide animations
      let g:neovide_scroll_animation_length=0.05
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        config = ''
          lua vim.lsp.enable('nixd')
        '';
      }

      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.bash
        p.css
        p.nix
      ]))

      {
        plugin = dracula-nvim;
        config = "colorscheme dracula";
      }
    ];
  };

  programs.neovide = {
    enable = true;
    settings = {
      #backtraces_path = "/path/to/neovide_backtraces.log" # see below for the default platform specific location
      fork = false;
      frame = "full";
      idle = true;
      #icon = "/full/path/to/neovide.ico" # Example path. Default icon is bundled. Use .icns on macOS.
      maximized = false;
      mouse-cursor-icon = "arrow";
      #neovim-bin = "/usr/bin/nvim" # in reality found dynamically on $PATH if unset
      no-multigrid = false;
      #srgb = false # platform-specific: false (Linux/macOS) or true (Windows)
      tabs = false;
      title-hidden = false;
      vsync = false;
      wsl = false;
     
      font = {
        normal = ["FiraCode Nerd Font"];
        size = 12.0;
      };

      box-drawing = {
        # "font-glyph", "native" or "selected-native"
        mode = "font-glyph";
      };
     
      box-drawing = {
        sizes = {
          # Thin and thick values respectively, for all sizes
          default = [2 4];
        };
      };
    };
  };
}

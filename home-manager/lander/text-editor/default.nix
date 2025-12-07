{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  programs.neovim = let
    lander-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "lander-nvim";
      src = ./lander-nvim;
    };
  in {
    enable = true;
    #defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = lander-nvim.overrideAttrs (old: {
          dependencies = [
            undotree
            hotpot-nvim
            rainbow-delimiters-nvim
            telescope-nvim
            dracula-nvim
            conform-nvim
            nvim-treesitter
            nvim-paredit
            nvim-lspconfig
          ];
        });
      }

      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.bash

        p.nix

        p.lua
        p.fennel

        p.markdown

        p.json
        p.toml
        p.yaml
        p.xml

        p.rust

        p.html
        p.css
      ]))
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
      multigrid = true;
      #srgb = false # platform-specific: false (Linux/macOS) or true (Windows)
      tabs = false;
      title-hidden = false;
      vsync = true;
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

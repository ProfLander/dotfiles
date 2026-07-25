{ pkgs, ... }:

{
  programs.neovim =
    let
      conjure-libre =
        with pkgs.vimPlugins;
        pkgs.vimUtils.buildVimPlugin {
          name = "conjure-libre";
          src = pkgs.fetchFromGitHub {
            owner = "ProfLander";
            repo = "conjure-libre";
            rev = "83a96ca75859f94b1482c2beff21b294d6616a37";
            sha256 = "sha256-rKYwhAK9CBggqGOys1g5z4z1bMS1zpiDwpqQeVT9hbc=";
          };
          dependencies = [
            plenary-nvim
          ];
          doCheck = false;
        };

      lander-nvim =
        with pkgs.vimPlugins;
        pkgs.vimUtils.buildVimPlugin {
          name = "lander-nvim";
          src = ./lander-nvim;
          dependencies = [
            plenary-nvim
            nvim-treesitter
            nvim-lspconfig
            nvim-surround
            nvim-autopairs
            which-key-nvim
            blink-cmp
            multicursor-nvim
            winshift-nvim
            undotree
            rainbow-delimiters-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            dracula-nvim
            conform-nvim
            auto-session
            conjure-libre
            nfnl
          ];
        };
    in
    {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withRuby = false;
      withPython3 = false;

      plugins = [
        lander-nvim

        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.bash

          p.nix

          p.lua
          p.fennel
          p.scheme
          p.racket

          p.markdown

          p.json
          p.hjson
          p.toml
          p.yaml
          p.xml

          p.rust

          p.html
          p.css
        ]))
      ];
    };

  home.packages = [
    pkgs.vim-set-root
  ];
}

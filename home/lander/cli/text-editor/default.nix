{ pkgs, lib, ... }:

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
            rev = "9b1b3d07083e455354bc96059b8a13e3e1075933";
            sha256 = "sha256-J9C2jTB5WxP775BGT24C0eWWs8Uez0nZ+166tuRjyuE=";
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

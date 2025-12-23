{ pkgs, ... }:

{
  programs.neovim =
    let
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
            hotpot-nvim
            rainbow-delimiters-nvim
            telescope-nvim
            telescope-fzf-native-nvim
            dracula-nvim
            conform-nvim
            auto-session
          ];
        };
    in
    {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = [
        lander-nvim

        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.bash

          p.nix

          p.lua
          p.fennel

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

  systemd.user.services.nvim = {
    Unit = {
      Description = "Run neovim as a headless server.";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''%h/.nix-profile/bin/nvim --headless --listen ${pkgs.nvim-server} -c "AutoSession restore default"'';
      ExecStop = ''%h/.nix-profile/bin/nvim --headless --server ${pkgs.nvim-server} --remote-expr "execute(\"AutoSession save default\")"'';
      SuccessExitStatus = 1;
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "%h";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

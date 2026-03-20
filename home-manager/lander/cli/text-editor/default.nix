{ pkgs, lib, ... }:

{
  programs.neovim =
    let
      fennel-indent = pkgs.vimUtils.buildVimPlugin {
        name = "fennel-indent.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "curist";
          repo = "fennel-indent.nvim";
          rev = "072a31cb99a05434f8b75100cae6b8ef01f32501";
          sha256 = "sha256-jXy6uumEIcuMk8siphNP0mKakvaPlQxewjhJH0LaOiU=";
        };
      };

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
            fennel-indent
            conjure-libre
            nfnl
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

  systemd.user.services.nvim = let
    start-nvim = pkgs.writeShellScript "start-nvim.sh" ''
      #!/bin/sh
      PATH=$PATH:${lib.makeBinPath (with pkgs; [
        # Basics
        coreutils
        diffutils
        git
        curl
        ripgrep
        fd

        # Toolchain
        gcc
        python3
        luajitPackages.fennel
        duck-repl

        # Formatters
        fnlfmt
        nixfmt
        rustfmt

        # Language servers
        bash-language-server
        fennel-ls
        ltex-ls
        lua-language-server
        nixd
        rust-analyzer
        tombi
        yaml-language-server
      ])}
      /home/lander/.nix-profile/bin/nvim --headless --listen ${pkgs.nvim-server} -c "AutoSession restore default"
    '';

    stop-nvim = pkgs.writeShellScript "stop-nvim.sh" ''
      #!bin/sh
      /home/lander/.nix-profile/bin/nvim --headless --server ${pkgs.nvim-server} --remote-expr "execute(\"AutoSession save default\")"
    '';
  in {
    Unit = {
      Description = "Run neovim as a headless server.";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${start-nvim}";
      ExecStop = "${stop-nvim}";
      SuccessExitStatus = 1;
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "%h";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Disabled due to incompatibility with neovide
  systemd.user.services.nvim-recorder = let
    record-nvim = pkgs.writeShellScript "record-nvim.sh" ''
      #!/bin/sh

      TIMESTAMP="$(date "+%Y-%m-%d")"

      while [[ ! $(nvim --clean --headless --server localhost:9034 --remote-expr "execute('pwd')") ]]
      do
        sleep 0.5
      done

      exec ${pkgs.asciinema}/bin/asciinema \
        rec \
        --append \
        --cols=100 \
        --rows=70 \
        -y \
        "casts/neovim-$TIMESTAMP.cast" \
        -c "~/.nix-profile/bin/nvim --clean --server localhost:9034 --remote-ui"
    '';
  in {
    Unit = {
      Description = "Record the neovim server via asciinema.";
      #PartOf = "nvim.service";
      #After = "nvim.service";
      #Requisite = "nvim.service";
    };
    Service = {
      Type = "simple";
      ExecStart = "${record-nvim}";
      Restart = "on-failure";
      WorkingDirectory = "%h";
    };
    Install = {
      #WantedBy = [ "default.target" ];
    };
  };
}

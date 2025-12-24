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

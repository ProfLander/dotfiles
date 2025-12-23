{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      server = "localhost:9034";
      neovide-client = "${pkgs.neovide}/bin/neovide --server ${server}";

      run-neovide = pkgs.writeShellApplication {
        name = "run-neovide";
        text = ''
          #!/bin/sh

          if [ ! -z "$1" ]
          then
            # If an argument was provided, instruct the neovim server to open it
            ${pkgs.neovim}/bin/nvim --server ${server} --remote "$1"
          fi

          if [ -z "$(pgrep neovide)" ]
          then
            # If neovide is not running, start it
            ${neovide-client}
          else
            # If already running, focus its window
            ${pkgs.niri}/bin/niri msg action focus-window \
              --id "$(${pkgs.niri}/bin/niri msg --json windows | \
                     ${pkgs.jq}/bin/jq ".[] | select(.app_id == \"main-text-editor\") | .id")"
          fi
        '';
      };

      vim-set-root = pkgs.writeShellApplication {
        name = "vim-set-root";
        text = ''
          #!/bin/sh

          TARGET="$(realpath "$1")";

          exec nvim --clean \
                    --headless \
                    --server ${server} \
                    --remote-expr "execute(\"cd $TARGET\")"
        '';
      };
    in
    {
      packages.${system} = {
        nvim-server = server;
        run-neovide = run-neovide;
        vim-set-root = vim-set-root;
      };
    };
}

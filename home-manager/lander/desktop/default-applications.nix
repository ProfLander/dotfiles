{ pkgs, ... }:

let
  nvim-server = "%h/.nix-profile/bin/nvim --headless --listen localhost:9034";

  neovide-client = "${pkgs.neovide}/bin/neovide --server localhost:9034";

  neovide = pkgs.writeShellScript "run-neovide.sh" ''
    #!/bin/sh

    if [ ! -z "$1" ]
    then
      # If an argument was provided, instruct the neovim server to open it
      ${pkgs.neovim}/bin/nvim --server localhost:9034 --remote "$1"
    fi

    if [ -z "$(pgrep neovide)" ]
    then
      # If neovide is not running, start it
      ${neovide-client}
    else
      # If already running, focus its window
      ${pkgs.niri}/bin/niri msg action focus-window \
        --id $(${pkgs.niri}/bin/niri msg --json windows | \
               ${pkgs.jq}/bin/jq ".[] | select(.app_id == \"neovide\") | .id")
    fi
  '';
in {
  systemd.user.services.nvim = {
    Unit = {
      Description = "Run neovim as a headless server.";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${nvim-server}";
      Restart = "always";
      RestartSec = 5;
      WorkingDirectory = "%h";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.desktopEntries = {
    neovide = {
      name = "Neovide";
      genericName = "Text Editor";
      exec = "${neovide} %U";
      terminal = false;
      icon = "nvim";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "neovide.desktop";
      "text/nix" = "neovide.desktop";
      "text/lua" = "neovide.desktop";
      "text/fnl" = "neovide.desktop";
      "text/fnlm" = "neovide.desktop";
      "text/html" = "neovide.desktop";
      "text/css" = "neovide.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml" = "firefox.desktop";
      "image/webp" = "firefox.desktop";

      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}

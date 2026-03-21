{ config, pkgs, ... }:

let
  gobs-cli = pkgs.buildGoModule {
    pname = "gobs-cli";
    version = "0.14.1";

    src = pkgs.fetchFromGitHub {
      owner = "onyx-and-iris";
      repo = "gobs-cli";
      rev = "1cf983a6479ccef4a440476ee4b8f55e38812284";
      hash = "sha256-2i9ffX1hE5yY41LSfmEIUBeL7CW70Qc99W0IKczy/Bk=";
    };

    vendorHash = "sha256-u5REDGvzeeaRU2BQTcrLuvBKYwsXS692797RkaUy3ec=";

    doCheck = false;
  };

  start-obs = "${pkgs.start-obs}/bin/start-obs";
  stop-obs = "${pkgs.stop-obs}/bin/stop-obs";

  graphical-program = pkgs.graphical-program;
  input-history = "${pkgs.input-history}/bin/input-history";

  alacritty-program =
    { class, exec }:
    ''
      ${pkgs.alacritty}/bin/alacritty --class ${class} \
                                      -o 'font.size=35' \
                                      -o 'colors.primary.background="#000000"' \
                                      -e ${exec}
    '';
in
{
  home.packages = [
    gobs-cli
    pkgs.input-history
  ];

  # OBS Studio for video recording
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      # WLRoots integration
      wlrobs

      # Pipewire capture
      obs-pipewire-audio-capture

      # AMD hardware acceleration
      obs-vaapi

      # Vulkan capture
      obs-vkcapture

      # Input overlay
      input-overlay
    ];
  };

  home.file."${config.xdg.configHome}/obs-studio/global.ini" = {
    source = ./global.ini;
    force = true;
  };

  home.file."${config.xdg.configHome}/obs-studio/user.ini" = {
    source = ./user.ini;
    force = true;
  };

  home.file."${config.xdg.configHome}/obs-studio/basic" = {
    source = ./basic;
    recursive = true;
    force = true;
  };

  systemd.user.services.obs = {
    Unit = {
      Description = "Open Broadcasting Software";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
      Wants = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
    };

    Service = {
      ExecStart = "${start-obs}";
      ExecStop = "${stop-obs}";
      KillSignal = "SIGKILL";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.input-monitor = graphical-program {
    desc = "Input monitor";
    exec-start = (
      alacritty-program {
        class = "obs-input-monitor";
        exec = ''
          ${input-history} \
            /home/lander/dotfiles/home-manager/util/input-history/config/keyboard/default.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/keyboard/niri.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/keyboard/neovim.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/trackball/default.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/gamepad/default.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/gamepad/streets-of-rage-remake/default.toml \
            /home/lander/dotfiles/home-manager/util/input-history/config/gamepad/streets-of-rage-remake/adam-hunter.toml
        '';
      }
    );
  };
}

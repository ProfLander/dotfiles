{ pkgs, ... }:

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

  oskd = pkgs.rustPlatform.buildRustPackage {
    name = "oskd";
    src = pkgs.fetchFromGitHub {
      owner = "Phosphorus-M";
      repo = "input-overlay-wayland";
      rev = "5bdbc64ec7498bc287b674fd1bc1205cda6beb69";
      sha256 = "sha256-u3t3+u+R8H/YJi+5fa8mieJmg56VzFWs4w1QyFgvveM=";
    };
    cargoHash = "sha256-1tcRC9+NZULCB2GzqYIoTCpqeXrKPDJx4JEJNTysiTk=";
    buildInputs = [
      pkgs.libx11.dev
      pkgs.libxi
      pkgs.libxtst
      pkgs.libxkbcommon
    ];
    nativeBuildInputs = [
      pkgs.pkg-config
    ];
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
    oskd
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
        exec =
        '' ${input-history} \
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

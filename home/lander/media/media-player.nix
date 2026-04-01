{ pkgs, ... }:

let
  graphical-program = pkgs.graphical-program;

  focus-app-id = "${pkgs.focus-app-id}/bin/focus-app-id";

  mpv-run = name: ''
    ${pkgs.mpv}/bin/mpv --player-operation-mode=pseudo-gui \
                        --wayland-app-id=${name} \
                        --input-ipc-server=/tmp/mpv-${name}
  '';

  mpv-play = pkgs.writeShellApplication {
    name = "mpv-play";

    runtimeInputs = [
      pkgs.socat
    ];

    text = ''
      echo "{ \"command\": [\"loadfile\", \"$2\"] }" | socat - "/tmp/mpv-$1"
      ${focus-app-id} "$1"
    '';
  };

in
{
  home.packages = [
    pkgs.mpv
    mpv-play
  ];

  systemd.user.services.media-video-player = graphical-program {
    desc = "Media video player";
    exec-start = mpv-run "media-video-player";
  };

  systemd.user.services.tv-player = graphical-program {
    desc = "TV media player";
    exec-start = mpv-run "tv-player";
  };
}

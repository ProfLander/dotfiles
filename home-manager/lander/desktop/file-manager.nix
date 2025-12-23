{ pkgs, ... }:

let
  graphical-program = pkgs.graphical-program;

  alacritty-program =
    { class, exec }:
    ''
      ${pkgs.alacritty}/bin/alacritty --class ${class} -e ${exec}
    '';

  broot-run = name: ''
    broot --listen ${name}
  '';

  broot-program = name: command: ''
    broot --listen ${name} -c " ${command}"
  '';
in {
  home.packages = [
      pkgs.nautilus
  ];

  systemd.user.services.chat-monitor = graphical-program {
    desc = "System monitor";
    exec-start = (
      alacritty-program {
        class = "chat-monitor";
        exec = broot-program "chat-monitor" "btop";
      }
    );
  };

  systemd.user.services.media-video-panel-left = graphical-program {
    desc = "Media video panel";
    exec-start = alacritty-program {
      class = "media-video-panel-left";
      exec = broot-run "media-video-panel-left";
    };
  };

  systemd.user.services.main-panel-left = graphical-program {
    desc = "Main left panel";
    exec-start = (
      alacritty-program {
        class = "main-panel-left";
        exec = broot-run "main-panel-left";
      }
    );
  };


  systemd.user.services.main-panel-right = graphical-program {
    desc = "Main right panel";
    exec-start = (
      alacritty-program {
        class = "main-panel-right";
        exec = broot-run "main-panel-right";
      }
    );
  };

}

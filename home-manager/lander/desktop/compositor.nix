{
  config,
  pkgs,
  inputs,
  ...
}:
let
  niri-flake = inputs.niri-flake;

  focus-app-id-bin = "${pkgs.focus-app-id}/bin/focus-app-id";
  window-action = "${pkgs.window-action}/bin/window-action";
  arrange-layout-bin = "${pkgs.arrange-layout}/bin/arrange-layout";

  obs-toggle-record-bin = "${pkgs.obs-toggle-record}/bin/obs-toggle-record";
  obs-save-replay-bin = "${pkgs.obs-save-replay}/bin/obs-save-replay";
  obs-switch-to-scene = "${pkgs.obs-switch-to-scene}/bin/obs-switch-to-scene";
in
{
  home.packages = [
    pkgs.app-id-to-niri-id
    pkgs.desktop-run
  ];

  systemd.user.services.arrange-layout = {
    Unit = {
      Description = "Arrange layout";
      Requisite = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };

    Service = {
      ExecStart = "${arrange-layout-bin}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.sessionVariables = {
    # Session info
    XDG_SESSION_TYPE = "wayland";

    # GTK
    GDK_SCALE = 2;
    GTK_THEME = "MacTahoe-Dark";
    GTK2_RC_FILES = "~/.themes/MacTahoe-Dark/gtk-2.0/gtkrc";

    # Qt

    ## Enable high-DPI
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_ENABLE_HIGHDPI_SCALING = 1;

    ## Prevent font aliasing in high-DPI Qt6 programs
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";

    ## Force wayland as the first choice of backend
    QT_QPA_PLATFORM = "wayland:xcb";

    ## Don't draw window decorations
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Enable Ozone Wayland support in Chrome and Electron
    NIXOS_OZONE_WL = "1";
  };

  imports = [ niri-flake.homeModules.config ];
  programs.niri.package = pkgs.niri;
  programs.niri.settings = {
    outputs = {
      DP-1 = {
        enable = true;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 143.999;
        };
        variable-refresh-rate = true;
        scale = 1.5;
        focus-at-startup = true;
        position = {
          x = 0;
          y = 0;
        };
      };
      DP-2 = {
        enable = true;
        mode = {
          width = 2560;
          height = 1440;
          refresh = 143.998;
        };
        variable-refresh-rate = false;
        position = {
          x = -2560;
          y = builtins.floor (((2160 / 1.5) - 1440) / 2);
        };
      };
      DP-3 = {
        enable = true;
        name = "DP-3";
        mode = {
          width = 1920;
          height = 1200;
          refresh = 59.95;
        };
        position = {
          x = builtins.ceil (3840 / 1.5);
          y = builtins.floor (((2160 / 1.5) - 1200) / 2);
        };
      };
      HDMI-A-1 = {
        enable = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 0 - 2560 - 1920;
          y = builtins.floor (((2160 / 1.5) - 1080) / 2);
        };
      };
    };

    input = {
      mod-key = "Alt";
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "5%";
      };
      warp-mouse-to-focus.enable = true;

      keyboard = {
        repeat-rate = 30;
        repeat-delay = 200;
      };

      trackball = {
        enable = true;

        accel-speed = -0.75;
        accel-profile = "flat";
        scroll-method = "on-button-down";
        scroll-button = 277;
      };

      button-scroll-factor = 0.25;
    };

    hotkey-overlay = {
      skip-at-startup = true;
    };

    prefer-no-csd = true;

    layout = {
      gaps = 10;
      always-center-single-column = true;

      default-column-width = {
        proportion = 0.4;
      };

      border = {
        enable = true;
        width = 2;
        active = {
          color = "#BD93F9";
        };
        inactive = {
          color = "#6272A4";
        };
      };

      focus-ring = {
        enable = true;
        width = 2;
        active = {
          color = "#FF79C6";
        };
        inactive = {
          color = "#BD93F9";
        };
      };

      tab-indicator = {
        enable = true;
        place-within-column = true;
        gap = -2;
        width = 8;
        length.total-proportion = 0.8;
        gaps-between-tabs = 0;
        corner-radius = 8;
        active = {
          color = "#FF79C6";
        };
        inactive = {
          color = "#6272A4";
        };
      };

      struts.left = 16;
      struts.right = 16;
    };

    workspaces = {
      ws-1-main-desktop = {
        open-on-output = "DP-1";
      };
      ws-2-main-editor = {
        open-on-output = "DP-1";
      };
      ws-3-main-work = {
        open-on-output = "DP-1";
      };
      ws-4-chat = {
        open-on-output = "DP-3";
      };
      ws-5-media-recording = {
        open-on-output = "DP-2";
      };
      ws-6-media-web = {
        open-on-output = "DP-2";
      };
      ws-7-media-video = {
        open-on-output = "DP-2";
      };
      ws-8-tv = {
        open-on-output = "HDMI-A-1";
      };
    };

    window-rules = [
      # General
      {
        open-on-workspace = "ws-1-main-desktop";
        open-focused = true;
        open-maximized = true;
        clip-to-geometry = true;
        draw-border-with-background = false;
        geometry-corner-radius = {
          top-left = 28.0;
          top-right = 28.0;
          bottom-left = 28.0;
          bottom-right = 28.0;
        };
      }
      # Screencast target
      {
        matches = [ { is-window-cast-target = true; } ];

        focus-ring = {
          active = {
            color = "#F1FA8C";
          };
        };

        border = {
          active = {
            color = "#50FA7B";
          };
          inactive = {
            color = "#F1FA8C";
          };
        };

        tab-indicator = {
          active = {
            color = "#50FA7B";
          };
          inactive = {
            color = "#F1FA8C";
          };
        };
      }
      # Main workspace
      {
        matches = [ { app-id = "main-panel-left"; } ];
        open-on-workspace = "ws-2-main-editor";
        open-maximized = false;
        open-focused = false;
        default-column-width = {
          proportion = 0.2;
        };
      }
      {
        matches = [
          {
            app-id = "main-text-editor";
          }
        ];

        open-on-workspace = "ws-2-main-editor";
        open-maximized = false;
        open-focused = true;

        default-column-width = {
          proportion = 0.8;
        };
      }
      {
        matches = [
          {
            app-id = "main-browser";
          }
        ];
        open-on-workspace = "ws-2-main-editor";
        open-maximized = false;
        open-focused = false;

        default-column-width = {
          proportion = 0.8;
        };

        default-column-display = "tabbed";
      }
      {
        matches = [
          {
            app-id = "main-panel-right";
          }
        ];
        open-on-workspace = "ws-2-main-editor";
        open-maximized = false;
        open-focused = false;
      }
      # Work workspace
      {
        matches = [ { app-id = "work-browser"; } ];
        open-on-workspace = "ws-3-main-work";
        open-maximized = true;
        open-focused = false;
      }
      # Chat workspace
      {
        matches = [ { app-id = "chat-monitor"; } ];
        open-on-workspace = "ws-4-chat";
        open-maximized = true;
        open-focused = true;
        #open-maximized-to-edges = true;
      }
      {
        matches = [ { app-id = "vesktop"; } ];

        open-on-workspace = "ws-4-chat";
        open-maximized = true;
        #open-maximized-to-edges = true;
        open-focused = false;

        default-column-width = {
          proportion = 0.6;
        };
      }
      {
        matches = [
          {
            app-id = "chat-browser";
          }
        ];
        open-on-workspace = "ws-4-chat";
        open-maximized = false;
        open-focused = false;
      }
      # Media/recording workspace
      {
        matches = [ { app-id = "com.obsproject.Studio"; } ];
        open-on-workspace = "ws-5-media-recording";
        open-maximized = true;
        open-floating = true;
        open-focused = false;
      }
      {
        matches = [ { app-id = "obs-input-monitor"; } ];
        open-on-workspace = "ws-5-media-recording";
        open-floating = true;
        open-focused = false;
        default-column-width = { fixed = 915; };
        default-window-height = { fixed = 1534; };
      }
      # Media/web workspace
      {
        matches = [ { app-id = "media-web-browser"; } ];
        open-on-workspace = "ws-6-media-web";
        open-maximized = true;
        open-focused = true;
      }
      # Media/video workspace
      {
        matches = [ { app-id = "media-video-panel-left"; } ];
        open-on-workspace = "ws-7-media-video";
        open-maximized = false;
        open-focused = false;
        default-column-width = {
          proportion = 0.2;
        };
      }
      {
        matches = [
          {
            app-id = "media-video-player";
          }
        ];
        open-on-workspace = "ws-7-media-video";
        open-maximized = true;
        open-focused = false;
      }
      # TV workspace
      {
        matches = [ { app-id = "tv-player"; } ];
        open-on-workspace = "ws-8-tv";
        open-fullscreen = true;
        open-focused = true;
      }
      # Application-specific
      {
        matches = [ { app-id = "love"; } ];
        open-on-workspace = "ws-1-main-editor";
        open-focused = true;
      }
    ];

    cursor = {
      hide-when-typing = true;
    };

    binds = with config.lib.niri.actions; {
      # Focus
      "Mod+h".action = spawn [
        "${window-action}"
        "wincmd h"
        ":root_up"
        "niri msg action focus-column-left"
      ];
      "Mod+j".action = spawn [
        "${window-action}"
        "wincmd j"
        ":line_down"
        "niri msg action
      focus-window-down"
      ];
      "Mod+k".action = spawn [
        "${window-action}"
        "wincmd k"
        ":line_up"
        "niri msg action focus-window-up"
      ];
      "Mod+l".action = spawn [
        "${window-action}"
        "wincmd l"
        ":root_down"
        "niri msg action
      focus-column-right"
      ];

      # Window movement
      "Mod+Ctrl+h".action = spawn [
        "${window-action}"
        "WinShift left"
        ""
        "niri
      msg action consume-or-expel-window-left"
      ];
      "Mod+Ctrl+j".action = spawn [
        "${window-action}"
        "WinShift down"
        ""
        "niri msg action move-window-down"
      ];
      "Mod+Ctrl+k".action = spawn [
        "${window-action}"
        "WinShift up"
        ""
        "niri msg action move-window-up"
      ];
      "Mod+Ctrl+l".action = spawn [
        "${window-action}"
        "WinShift right"
        ""
        "niri msg action
      consume-or-expel-window-right"
      ];

      # Window / column sizing
      "Mod+Shift+h".action = spawn [
        "${window-action}"
        "wincmd 8<"
        ""
        "niri
      msg action set-column-width -10%"
      ];
      "Mod+Shift+j".action = spawn [
        "${window-action}"
        "wincmd 4+"
        ""
        "niri msg action set-window-height
      +10%"
      ];
      "Mod+Shift+k".action = spawn [
        "${window-action}"
        "wincmd 4-"
        ""
        "niri msg action set-window-height -10%"
      ];
      "Mod+Shift+l".action = spawn [
        "${window-action}"
        "wincmd 8>"
        ""
        "niri msg action set-column-width
      +10%"
      ];

      # Column movement
      "Mod+Ctrl+Shift+h".action = move-column-left;
      #"Mod+Ctrl+Shift+j".action = ???; "Mod+Ctrl+Shift+k".action = ???;
      "Mod+Ctrl+Shift+l".action = move-column-right;

      # Application focus
      "Super+h".action = spawn [
        "${focus-app-id-bin}"
        "main-panel-left"
      ];
      "Super+j".action = spawn [
        "${focus-app-id-bin}"
        "main-text-editor"
      ];
      "Super+k".action = spawn [
        "${focus-app-id-bin}"
        "main-browser"
      ];
      "Super+l".action = spawn [
        "${focus-app-id-bin}"
        "main-panel-right"
      ];
      "Super+p".action = spawn [
        "${focus-app-id-bin}"
        "work-browser"
      ];
      "Super+Semicolon".action = focus-workspace "ws-1-main-desktop";

      "Super+y".action = spawn [
        "${focus-app-id-bin}"
        "chat-monitor"
      ];
      "Super+u".action = spawn [
        "${focus-app-id-bin}"
        "vesktop"
      ];
      "Super+i".action = spawn [
        "${focus-app-id-bin}"
        "chat-browser"
      ];

      "Super+n".action = spawn [
        "${focus-app-id-bin}"
        "com.obsproject.Studio"
      ];
      "Super+m".action = spawn [
        "${focus-app-id-bin}"
        "media-web-browser"
      ];
      "Super+Comma".action = spawn [
        "${focus-app-id-bin}"
        "media-video-player"
      ];
      "Super+Period".action = spawn [
        "${focus-app-id-bin}"
        "media-video-panel-left"
      ];

      "Super+Tab".action = spawn [
        "${focus-app-id-bin}"
        "tv-player"
      ];

      # Move across monitors
      "Super+Shift+h".action = move-window-to-monitor-left;
      "Super+Shift+j".action = move-window-to-workspace-down;
      "Super+Shift+k".action = move-window-to-workspace-up;
      "Super+Shift+l".action = move-window-to-monitor-right;

      "Super+Ctrl+Shift+h".action = move-column-to-monitor-left;
      "Super+Ctrl+Shift+j".action = move-column-to-workspace-down;
      "Super+Ctrl+Shift+k".action = move-column-to-workspace-up;
      "Super+Ctrl+Shift+l".action = move-column-to-monitor-right;

      # Overview
      "Super+Space".action = toggle-overview;

      # Tabs
      "Super+Backspace".action = toggle-column-tabbed-display;

      # Spawn new
      "Mod+Space".action = spawn [
        "${window-action}"
        "wincmd v"
        ""
        "alacritty -e broot"
      ];
      "Mod+Ctrl+Space".action = spawn [
        "${window-action}"
        "wincmd s"
        ""
        "alacritty -e broot"
      ];

      # Close
      "Mod+Backspace".action = spawn [
        "${window-action}"
        "wincmd c"
        ""
        "niri msg action close-window"
      ];

      # Maximize
      "Mod+f".action = maximize-column;
      "Mod+Ctrl+f".action = maximize-window-to-edges;
      "Mod+Ctrl+Shift+f".action = fullscreen-window;

      # Screencasting
      "Mod+g".action = set-dynamic-cast-window;
      "Mod+t".action = set-dynamic-cast-monitor;

      "Mod+F1".action = spawn [ obs-switch-to-scene "Desktop (16:9)" ];
      "Mod+F2".action = spawn [ obs-switch-to-scene "Desktop + Input (4:3)" ];
      "Mod+F3".action = spawn [ obs-switch-to-scene "Game (16:9)" ];
      "Mod+F4".action = spawn [ obs-switch-to-scene "Game + Input (4:3)" ];
      "Mod+F5".action = spawn [ obs-switch-to-scene "Desktop Game + Input (4:3)" ];

      # Screen capture
      "Mod+r".action = spawn [ "${obs-toggle-record-bin}" ];
      "Mod+e".action = spawn [ "${obs-save-replay-bin}" ];
      "Mod+w".action = spawn [
        "niri"
        "msg"
        "action"
        "screenshot-window"
      ];
      "Mod+q".action = spawn [
        "niri"
        "msg"
        "action"
        "screenshot-screen"
      ];
      "Mod+a".action = spawn [
        "niri"
        "msg"
        "action"
        "screenshot"
      ];

      # Help
      "Mod+Slash".action = show-hotkey-overlay;

      # Quit
      "Mod+Super+q".action = quit;

      # Quit
      "Mod+MouseMiddle".action = toggle-window-floating;
    };

    gestures.hot-corners.enable = false;
  };
}

{ config, pkgs, inputs, ... }:

let
  niri-flake = inputs.niri-flake;
  niri = inputs.niri.packages.${pkgs.system}.default;

  obelix-minibuffer = pkgs.writeShellScript "obelix-minibuffer.sh" ''
    #!/bin/sh
    MONITOR="$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .output')"
    echo "Monitor: $MONITOR"
    echo "obelix minibuffer $MONITOR $1"
    obelix minibuffer "$MONITOR" "$1"
  '';
in {
  home.sessionVariables = {
      # Session info
      XDG_SESSION_TYPE = "wayland";
  
      # Default programs
      TERM = "alacritty";
      VISUAL = "emacsclient -c";
      BROWSER = "firefox --new-window";
  
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
  };

  imports = [ niri-flake.homeModules.config ];
  programs.niri.package = niri;
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
          y = builtins.floor(((2160 / 1.5) - 1440) / 2);
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
          x = builtins.ceil(3840 / 1.5);
          y = builtins.floor(((2160 / 1.5) - 1200) / 2);
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
          y = builtins.floor(((2160 / 1.5) - 1080) / 2);
        };
      };
    };

    input = {
      mod-key = "Alt";
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount="5%";
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

    prefer-no-csd = true;

    layout = {
      gaps = 10;
      always-center-single-column = true;

      default-column-width = {
        proportion = 0.5;
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

    window-rules = [
      {
        clip-to-geometry = true;
        draw-border-with-background = false;
        geometry-corner-radius = {
          top-left = 28.0;
          top-right = 28.0;
          bottom-left = 28.0;
          bottom-right = 28.0;
        };
      }
    ];

    spawn-at-startup = [
      { sh = "swaybg -i ${./wallpaper/wallpaper-dark-blur-abstract.jpg} -m fill"; }
      { argv = ["obelix"]; }
    ];

    cursor = {
      hide-when-typing = true;
    };

    binds = with config.lib.niri.actions; {
      "Mod+h".action = focus-column-left;
      "Mod+j".action = focus-window-down;
      "Mod+k".action = focus-window-up;
      "Mod+l".action = focus-column-right;
       
      "Mod+Ctrl+h".action = consume-or-expel-window-left;
      "Mod+Ctrl+j".action = move-window-down;
      "Mod+Ctrl+k".action = move-window-up;
      "Mod+Ctrl+l".action = consume-or-expel-window-right;

      "Mod+Shift+h".action = set-column-width "-10%";
      "Mod+Shift+j".action = set-window-height "+10%";
      "Mod+Shift+k".action = set-window-height "-10%";
      "Mod+Shift+l".action = set-column-width "+10%";

      "Mod+Ctrl+Shift+h".action = move-column-left;
      #"Mod+Ctrl+Shift+j".action = ???;
      #"Mod+Ctrl+Shift+k".action = ???;
      "Mod+Ctrl+Shift+l".action = move-column-right;

      "Super+h".action = focus-monitor-left;
      "Super+j".action = focus-workspace-down;
      "Super+k".action = focus-workspace-up;
      "Super+l".action = focus-monitor-right;

      "Super+Shift+h".action = move-window-to-monitor-left;
      "Super+Shift+j".action = move-window-to-workspace-down;
      "Super+Shift+k".action = move-window-to-workspace-up;
      "Super+Shift+l".action = move-window-to-monitor-right;

      "Super+Ctrl+Shift+h".action = move-column-to-monitor-left;
      "Super+Ctrl+Shift+j".action = move-column-to-workspace-down;
      "Super+Ctrl+Shift+k".action = move-column-to-workspace-up;
      "Super+Ctrl+Shift+l".action = move-column-to-monitor-right;

      "Super+Space".action = toggle-overview;
      "Super+Backspace".action = toggle-column-tabbed-display;
       
      "Mod+Space".action = spawn ["alacritty" "-e" "broot"];
      "Mod+Ctrl+Space".action = spawn "alacritty";

      "Mod+Backspace".action = close-window;

      "Mod+f".action = toggle-windowed-fullscreen;
      "Mod+Ctrl+f".action = maximize-column;
      "Mod+Ctrl+Shift+f".action = fullscreen-window;

      "Mod+Super+q".action = quit;

      "Mod+Slash".action = show-hotkey-overlay;

      "Mod+r".action = spawn ["${obelix-minibuffer}" ":shell"];
      "Mod+e".action = spawn ["${obelix-minibuffer}" ":desktop"];
      "Mod+w".action = spawn ["${obelix-minibuffer}" ":web"];
    };

    gestures.hot-corners.enable = false;
  };
}

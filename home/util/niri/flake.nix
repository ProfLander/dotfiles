{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      app-id-to-niri-id = pkgs.writeShellApplication {
        name = "app-id-to-niri-id";
        text = ''
          #!/bin/sh

          if [[ $# == 0 ]]
          then
            >&2 echo "Missing app ID argument"
            exit
          fi

          NIRI_ID="$(niri msg --json windows | jq -r ".[] | select(.app_id == \"$1\") | .id")"
          if [[ -z $NIRI_ID ]]
          then
            >&2 echo "No such app ID: $1"
          else
            echo "$NIRI_ID"
          fi
        '';
      };
      app-id-to-niri-id-bin = "${app-id-to-niri-id}/bin/app-id-to-niri-id";

      window-action = pkgs.writeShellApplication {
        name = "window-action";
        text = ''
          #!/bin/sh

          FOCUSED_APP="$(niri msg --json focused-window | jq -r '.app_id')"

          if [[ $FOCUSED_APP == "main-text-editor" ]]
          then
            exec nvim --clean \
                      --headless \
                      --server localhost:9034 \
                      --remote-expr "execute(\"$1\")"
          elif [[ $FOCUSED_APP == "main-panel-left" ||
                  $FOCUSED_APP == "main-panel-right" ||
                  $FOCUSED_APP == "media-video-panel-left" ]]
          then
            exec ${pkgs.broot}/bin/broot --send "$FOCUSED_APP" -c "$2"
          else
            exec $3
          fi
        '';
      };

      focus-app-id = pkgs.writeShellApplication {
        name = "focus-app-id";
        text = ''
          #!/bin/sh

          NIRI_ID="$(${app-id-to-niri-id-bin} "$1")"

          if [ -z "$NIRI_ID" ]
          then
            exit
          fi

          niri msg action focus-window --id "$NIRI_ID"
        '';
      };

      arrange-layout = pkgs.writeShellApplication {
        name = "arrange-layout";
        text = ''
          #!/bin/sh

          MAIN_LEFT=
          MAIN_EDITOR=
          MAIN_BROWSER=
          MAIN_RIGHT=
          CHAT_MONITOR=
          CHAT_VESKTOP=
          CHAT_BROWSER=
          MEDIA_BROWSER=
          VIDEO_PANEL=
          VIDEO_PLAYER=

          while [[ -z $MAIN_LEFT ||
                   -z $MAIN_EDITOR ||
                   -z $MAIN_BROWSER ||
                   -z $MAIN_RIGHT ||
                   -z $CHAT_MONITOR ||
                   -z $CHAT_VESKTOP ||
                   -z $CHAT_BROWSER ||
                   -z $MEDIA_BROWSER ||
                   -z $VIDEO_PANEL ||
                   -z $VIDEO_PLAYER
                   ]]
          do
            sleep 0.5
            MAIN_LEFT=$(${app-id-to-niri-id-bin} "main-panel-left")
            MAIN_EDITOR=$(${app-id-to-niri-id-bin} "main-text-editor")
            MAIN_BROWSER=$(${app-id-to-niri-id-bin} "main-browser")
            MAIN_RIGHT=$(${app-id-to-niri-id-bin} "main-panel-right")
            CHAT_MONITOR=$(${app-id-to-niri-id-bin} "chat-monitor")
            CHAT_VESKTOP=$(${app-id-to-niri-id-bin} "vesktop")
            CHAT_BROWSER=$(${app-id-to-niri-id-bin} "chat-browser")
            MEDIA_BROWSER=$(${app-id-to-niri-id-bin} "media-web-browser")
            VIDEO_PANEL=$(${app-id-to-niri-id-bin} "media-video-panel-left")
            VIDEO_PLAYER=$(${app-id-to-niri-id-bin} "media-video-player")
          done

          niri msg action focus-window --id "$MAIN_LEFT"
          niri msg action move-column-to-last
          niri msg action focus-window --id "$MAIN_BROWSER"
          niri msg action expel-window-from-column
          niri msg action move-column-to-last
          niri msg action focus-window --id "$MAIN_EDITOR"
          niri msg action move-column-to-last
          niri msg action focus-window --id "$MAIN_RIGHT"
          niri msg action move-column-to-last

          niri msg action focus-window --id "$MAIN_EDITOR"
          niri msg action consume-or-expel-window-left

          niri msg action focus-window --id "$CHAT_MONITOR"
          niri msg action move-column-to-last
          niri msg action focus-window --id "$CHAT_VESKTOP"
          niri msg action move-column-to-last
          niri msg action focus-window --id "$CHAT_BROWSER"
          niri msg action move-column-to-last

          niri msg action focus-window --id "$VIDEO_PLAYER"
          niri msg action move-column-to-last
          niri msg action focus-window --id "$VIDEO_PANEL"
          niri msg action move-column-to-last

          niri msg action focus-window --id "$MEDIA_BROWSER"
          niri msg action focus-window --id "$CHAT_MONITOR"
          niri msg action focus-window --id "$MAIN_LEFT"
          niri msg action focus-window --id "$MAIN_EDITOR"

          niri msg action set-dynamic-cast-monitor
        '';
      };

      focus-app-id-bin = "${focus-app-id}/bin/focus-app-id";
      window-action-bin = "${window-action}/bin/window-action";

      obs-toggle-record = pkgs.writeShellApplication {
        name = "obs-toggle-record";
        text = ''
          gobs-cli record toggle
          niri msg action focus-window --id "$(${app-id-to-niri-id-bin} "com.obsproject.Studio")"
        '';
      };

      obs-toggle-record-bin = "${obs-toggle-record}/bin/obs-toggle-record";

      obs-save-replay = pkgs.writeShellApplication {
        name = "obs-save-replay";
        text = ''
          gobs-cli replaybuffer status | grep "Replay buffer is active."
          if [ $? = 1 ]; then
            gobs-cli replaybuffer start
          else
            gobs-cli replaybuffer save
          fi
          niri msg action focus-window --id "$(${app-id-to-niri-id-bin} "com.obsproject.Studio")"
        '';
      };

      obs-save-replay-bin = "${obs-save-replay}/bin/obs-save-replay";

      obs-switch-to-scene = pkgs.writeShellApplication {
        name = "obs-switch-to-scene";
        text = ''
          gobs-cli scene switch "$1"
        '';
      };

      obs-switch-to-scene-bin = "${obs-switch-to-scene}/bin/obs-switch-to-scene";
    in
    {
      packages.${system} = {
        window-action = window-action;
        app-id-to-niri-id = app-id-to-niri-id;
        focus-app-id = focus-app-id;
        arrange-layout = arrange-layout;
      };

      niri-config =
        config:
        ''
          input {
              keyboard {
                  xkb {
                      layout ""
                      model ""
                      rules ""
                      variant ""
                  }
                  repeat-delay 200
                  repeat-rate 30
                  track-layout "global"
              }
              touchpad {
                  tap
                  natural-scroll
              }
              trackball {
                  accel-speed -0.750000
                  accel-profile "flat"
                  scroll-button 277
                  scroll-method "on-button-down"
              }
              warp-mouse-to-focus
              focus-follows-mouse max-scroll-amount="5%"
              mod-key "Alt"
              //button-scroll-factor 0.250000
          }

        screenshot-path "${config.home.homeDirectory}/pictures/screenshots/%Y-%m-%d-%H-%M-%S.png"

        prefer-no-csd

        layout {
            gaps 10
            struts {
                left 16
                right 16
                top 0
                bottom 0
            }
            focus-ring {
                width 2
                active-color "#FF79C6"
                inactive-color "#BD93F9"
            }
            border {
                width 2
                active-color "#BD93F9"
                inactive-color "#6272A4"
            }
            tab-indicator {
                place-within-column
                gap -2
                width 8
                length total-proportion=0.800000
                position "left"
                gaps-between-tabs 0
                corner-radius 8
                active-color "#FF79C6"
                inactive-color "#6272A4"
            }
            default-column-width { proportion 0.400000; }
            center-focused-column "never"
            always-center-single-column
        }

        cursor {
            xcursor-theme "default"
            xcursor-size 24
            hide-when-typing
        }

        hotkey-overlay { skip-at-startup; }

        binds {
            Mod+Backspace { spawn "${window-action-bin}" "wincmd c" "" "niri msg action close-window"; }
            Mod+Ctrl+Shift+f { fullscreen-window; }
            Mod+Ctrl+Shift+h { move-column-left; }
            Mod+Ctrl+Shift+l { move-column-right; }
            Mod+Ctrl+Space { spawn "${window-action-bin}" "wincmd s" "" "alacritty -e broot"; }
            Mod+Ctrl+f { maximize-window-to-edges; }
            Mod+Ctrl+h { spawn "${window-action-bin}" "WinShift left" "" "niri\n      msg action consume-or-expel-window-left"; }
            Mod+Ctrl+j { spawn "${window-action-bin}" "WinShift down" "" "niri msg action move-window-down"; }
            Mod+Ctrl+k { spawn "${window-action-bin}" "WinShift up" "" "niri msg action move-window-up"; }
            Mod+Ctrl+l { spawn "${window-action-bin}" "WinShift right" "" "niri msg action\n      consume-or-expel-window-right"; }
            Mod+F1 { spawn "${obs-switch-to-scene-bin}" "Desktop (16:9)"; }
            Mod+F2 { spawn "${obs-switch-to-scene-bin}" "Desktop + Input (4:3)"; }
            Mod+F3 { spawn "${obs-switch-to-scene-bin}" "Game (16:9)"; }
            Mod+F4 { spawn "${obs-switch-to-scene-bin}" "Game + Input (4:3)"; }
            Mod+F5 { spawn "${obs-switch-to-scene-bin}" "Desktop Game + Input (4:3)"; }
            Mod+MouseMiddle { toggle-window-floating; }
            Mod+Shift+h { spawn "${window-action-bin}" "wincmd 8<" "" "niri\n      msg action set-column-width -10%"; }
            Mod+Shift+j { spawn "${window-action-bin}" "wincmd 4+" "" "niri msg action set-window-height\n      +10%"; }
            Mod+Shift+k { spawn "${window-action-bin}" "wincmd 4-" "" "niri msg action set-window-height -10%"; }
            Mod+Shift+l { spawn "${window-action-bin}" "wincmd 8>" "" "niri msg action set-column-width\n      +10%"; }
            Mod+Slash { show-hotkey-overlay; }
            Mod+Space { spawn "${window-action-bin}" "wincmd v" "" "alacritty -e broot"; }
            Mod+Super+q { quit; }
            Mod+a { spawn "niri" "msg" "action" "screenshot"; }
            Mod+e { spawn "${obs-save-replay-bin}"; }
            Mod+f { maximize-column; }
            Mod+g { set-dynamic-cast-window; }
            Mod+h { spawn "${window-action-bin}" "wincmd h" ":root_up" "niri msg action focus-column-left"; }
            Mod+j { spawn "${window-action-bin}" "wincmd j" ":line_down" "niri msg action\n      focus-window-down"; }
            Mod+k { spawn "${window-action-bin}" "wincmd k" ":line_up" "niri msg action focus-window-up"; }
            Mod+l { spawn "${window-action-bin}" "wincmd l" ":root_down" "niri msg action\n      focus-column-right"; }
            Mod+q { spawn "niri" "msg" "action" "screenshot-screen"; }
            Mod+r { spawn "${obs-toggle-record-bin}"; }
            Mod+t { set-dynamic-cast-monitor; }
            Mod+w { spawn "niri" "msg" "action" "screenshot-window"; }
            Super+Backspace { toggle-column-tabbed-display; }
            Super+Comma { spawn "${focus-app-id-bin}" "media-video-player"; }
            Super+Ctrl+Shift+h { move-column-to-monitor-left; }
            Super+Ctrl+Shift+j { move-column-to-workspace-down; }
            Super+Ctrl+Shift+k { move-column-to-workspace-up; }
            Super+Ctrl+Shift+l { move-column-to-monitor-right; }
            Super+Period { spawn "${focus-app-id-bin}" "media-video-panel-left"; }
            Super+Semicolon { focus-workspace "ws-1-main-desktop"; }
            Super+Shift+h { move-window-to-monitor-left; }
            Super+Shift+j { move-window-to-workspace-down; }
            Super+Shift+k { move-window-to-workspace-up; }
            Super+Shift+l { move-window-to-monitor-right; }
            Super+Space { toggle-overview; }
            Super+Tab { spawn "${focus-app-id-bin}" "tv-player"; }
            Super+h { spawn "${focus-app-id-bin}" "main-panel-left"; }
            Super+i { spawn "${focus-app-id-bin}" "chat-browser"; }
            Super+j { spawn "${focus-app-id-bin}" "main-text-editor"; }
            Super+k { spawn "${focus-app-id-bin}" "main-browser"; }
            Super+l { spawn "${focus-app-id-bin}" "main-panel-right"; }
            Super+m { spawn "${focus-app-id-bin}" "media-web-browser"; }
            Super+n { spawn "${focus-app-id-bin}" "com.obsproject.Studio"; }
            Super+p { spawn "${focus-app-id-bin}" "work-browser"; }
            Super+u { spawn "${focus-app-id-bin}" "vesktop"; }
            Super+y { spawn "${focus-app-id-bin}" "chat-monitor"; }
        }

        workspace "ws-1-main-desktop" { open-on-output "DP-1"; }
        workspace "ws-2-main-editor" { open-on-output "DP-1"; }
        workspace "ws-3-main-work" { open-on-output "DP-1"; }
        workspace "ws-4-chat" { open-on-output "DP-3"; }
        workspace "ws-5-media-recording" { open-on-output "DP-2"; }
        workspace "ws-6-media-web" { open-on-output "DP-2"; }
        workspace "ws-7-media-video" { open-on-output "DP-2"; }
        workspace "ws-8-tv" { open-on-output "HDMI-A-1"; }

        window-rule {
            open-on-workspace "ws-1-main-desktop"
            open-maximized true
            open-focused true
            draw-border-with-background false
            geometry-corner-radius 28.000000 28.000000 28.000000 28.000000
            clip-to-geometry true
            background-effect {
                blur true
                xray true
                noise 0.050000
                saturation 1
            }
        }

        window-rule {
            match is-window-cast-target=true
            border {
                active-color "#50FA7B"
                inactive-color "#F1FA8C"
            }
            focus-ring { active-color "#F1FA8C"; }
            tab-indicator {
                active-color "#50FA7B"
                inactive-color "#F1FA8C"
            }
        }

        window-rule {
            match app-id="main-panel-left"
            default-column-width { proportion 0.200000; }
            open-on-workspace "ws-2-main-editor"
            open-maximized false
            open-focused false
        }

        window-rule {
            match app-id="main-text-editor"
            default-column-width { proportion 0.800000; }
            open-on-workspace "ws-2-main-editor"
            open-maximized false
            open-focused true
        }

        window-rule {
            match app-id="main-browser"
            default-column-width { proportion 0.800000; }
            default-column-display "tabbed"
            open-on-workspace "ws-2-main-editor"
            open-maximized false
            open-focused false
        }

        window-rule {
            match app-id="main-panel-right"
            open-on-workspace "ws-2-main-editor"
            open-maximized false
            open-focused false
        }

        window-rule {
            match app-id="work-browser"
            open-on-workspace "ws-3-main-work"
            open-maximized true
            open-focused false
        }

        window-rule {
            match app-id="chat-monitor"
            open-on-workspace "ws-4-chat"
            open-maximized true
            open-focused true
        }

        window-rule {
            match app-id="vesktop"
            default-column-width { proportion 0.600000; }
            open-on-workspace "ws-4-chat"
            open-maximized true
            open-focused false
        }

        window-rule {
            match app-id="chat-browser"
            open-on-workspace "ws-4-chat"
            open-maximized false
            open-focused false
        }

        window-rule {
            match app-id="com.obsproject.Studio"
            default-column-width { fixed 2532; }
            default-window-height { fixed 1412; }
            open-on-workspace "ws-5-media-recording"
            open-floating true
            open-focused false
        }

        window-rule {
            match app-id="obs-input-monitor"
            default-column-width { fixed 915; }
            default-window-height { fixed 1534; }
            open-on-workspace "ws-5-media-recording"
            open-floating true
            open-focused false
        }

        window-rule {
            match app-id="media-web-browser"
            open-on-workspace "ws-6-media-web"
            open-maximized true
            open-focused true
        }

        window-rule {
            match app-id="media-video-panel-left"
            default-column-width { proportion 0.200000; }
            open-on-workspace "ws-7-media-video"
            open-maximized false
            open-focused false
        }

        window-rule {
            match app-id="media-video-player"
            open-on-workspace "ws-7-media-video"
            open-maximized true
            open-focused false
        }

        window-rule {
            match app-id="tv-player"
            open-on-workspace "ws-8-tv"
            open-fullscreen true
            open-focused true
        }

        window-rule {
            match app-id="love"
            open-on-workspace "ws-1-main-editor"
            open-focused true
        }

        gestures { hot-corners { off; }; }
      '';
    };
}

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
    in
    {
      packages.${system} = {
        window-action = window-action;
        app-id-to-niri-id = app-id-to-niri-id;
        focus-app-id = focus-app-id;
        arrange-layout = arrange-layout;
      };
    };
}

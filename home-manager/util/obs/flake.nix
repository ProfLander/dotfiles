{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    util-niri.url = ../niri;
  };

  outputs =
    { nixpkgs, util-niri, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      app-id-to-niri-id = util-niri.packages.${system}.app-id-to-niri-id;
      app-id-to-niri-id-bin = "${app-id-to-niri-id}/bin/app-id-to-niri-id";

        start-obs = pkgs.writeShellApplication {
          name = "start-obs";
          text = ''
            #!/bin/sh

            [ -d ~/.config/obs-studio/.sentinel ] && /run/current-system/sw/bin/rm -rf ~/.config/obs-studio/.sentinel
            [ -f ~/.config/obs-studio/safe_mode ] && /run/current-system/sw/bin/rm ~/.config/obs-studio/safe_mode
            exec ~/.nix-profile/bin/obs --startreplaybuffer
          '';
        };

        stop-obs = pkgs.writeShellApplication {
          name = "stop-obs";
          text = ''
            #!/bin/sh

            gobs-cli replaybuffer stop
          '';
        };

        obs-toggle-record = pkgs.writeShellApplication {
          name = "obs-toggle-record"; text = ''
            gobs-cli record toggle
            niri msg action focus-window --id "$(${app-id-to-niri-id-bin} "com.obsproject.Studio")"
          '';
        };

        obs-save-replay = pkgs.writeShellApplication {
          name = "obs-save-replay";
          text = ''
            gobs-cli replaybuffer save
            niri msg action focus-window --id "$(${app-id-to-niri-id-bin} "com.obsproject.Studio")"
          '';
        };

        obs-switch-to-scene = pkgs.writeShellApplication {
          name = "obs-switch-to-scene";
          text = ''
            gobs-cli scene switch "$1"
          '';
        };
    in
    {
      packages.${system} = {
        start-obs = start-obs;
        stop-obs = stop-obs;
        obs-toggle-record = obs-toggle-record;
        obs-save-replay = obs-save-replay;
        obs-switch-to-scene = obs-switch-to-scene;
      };
    };
}

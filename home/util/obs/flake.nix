{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      start-obs = pkgs.writeShellApplication {
        name = "start-obs";
        text = ''
          #!/bin/sh

          [ -d ~/.config/obs-studio/.sentinel ] && rm -rf ~/.config/obs-studio/.sentinel
          [ -f ~/.config/obs-studio/safe_mode ] && rm ~/.config/obs-studio/safe_mode
          exec obs
        '';
      };

      stop-obs = pkgs.writeShellApplication {
        name = "stop-obs";
        text = ''
          #!/bin/sh

          gobs-cli record stop
          gobs-cli replaybuffer stop
        '';
      };
    in
    {
      packages.${system} = {
        start-obs = start-obs;
        stop-obs = stop-obs;
      };
    };
}

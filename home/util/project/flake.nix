{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      project-detect = pkgs.writeShellApplication {
        name = "project-detect";
        text = ''
          #!/bin/sh

          if [[ $# == 0 ]]
          then
            >&2 echo "project-detect: Missing arguments"
            exit 1
          fi

          TARGET=$(realpath "$1")

          while [ "$TARGET" != "/" ]
          do
            OUT=""

            [ -f "$TARGET/Cargo.toml" ]    && OUT="cargo"
            [ -f "$TARGET/go.mod" ]        && OUT="go"
            [ -f "$TARGET/Makefile" ]      && OUT="make"
            [ -f "$TARGET/justfile" ]      && OUT="just"

            if [ ! -z "$OUT" ]
            then
              echo "$OUT"
              echo "$TARGET"
              exit 0
            else
              TARGET=$(dirname "$TARGET")
            fi
          done

          echo "unknown"
          exit 0
        '';
      };

      dispatch = pkgs.writeShellScript "dispatch.sh" ''
          #!/bin/sh

          ACTIVE_WIN=$(niri msg --json focused-window | jq -r '.id')
          PROJECT_TARGET=$(${project-detect}/bin/project-detect "$1")
          OK=0

          echo

          if [[ "$PROJECT_TARGET" == "unknown" ]]
          then
            >&2 echo "Unrecognized project at $1"
          else
            PROJECT=$(echo "$PROJECT_TARGET" | awk "NR==1")
            TARGET=$(echo "$PROJECT_TARGET" | awk "NR==2")

            echo "$PROJECT: $2 $TARGET..."
            echo

            [[ $PROJECT == "cargo" ]] && cd "$TARGET" && ${pkgs.cargo}/bin/cargo $2 && OK=1
            [[ $PROJECT == "go" ]]    && ${pkgs.go}/bin/go $2 "$TARGET" && OK=1
            [[ $PROJECT == "make" ]]  && make $2 "$TARGET" && OK=1
            [[ $PROJECT == "just" ]]  && ${pkgs.just}/bin/just -d "$TARGET" -f "$TARGET/justfile" $2 && OK=1
          fi

          if [[ $OK == 0 ]]
          then
            echo
            echo "Press return to continue..."
            read -r
          fi

          [ ! -z "$ACTIVE_WIN" ] && niri msg action focus-window --id "$ACTIVE_WIN"
      '';

      project-clean = pkgs.writeShellApplication {
        name = "project-clean";
        text = ''
          #!/bin/sh
          exec ${dispatch} "$1" clean
        '';
      };

      project-build = pkgs.writeShellApplication {
        name = "project-build";
        text = ''
          #!/bin/sh
          exec ${dispatch} "$1" build
        '';
      };

      project-run = pkgs.writeShellApplication {
        name = "project-run";
        text = ''
          #!/bin/sh
          exec ${dispatch} "$1" run
        '';
      };

      project-test = pkgs.writeShellApplication {
        name = "project-test";
        text = ''
          #!/bin/sh
          exec ${dispatch} "$1" test
        '';
      };

      project = pkgs.writeShellApplication {
        name = "project";
        text = ''
          #!/bin/sh

          #echo "project: $*"

          [[ $1 == "clean" ]] && exec ${project-clean}/bin/project-clean "$2"
          [[ $1 == "build" ]] && exec ${project-build}/bin/project-build "$2"
          [[ $1 == "run" ]] && exec ${project-run}/bin/project-run "$2"
          [[ $1 == "test" ]] && exec ${project-test}/bin/project-test "$2"

          [[ $1 == "clean" ]] && exec ${project-clean}/bin/project-clean "$2"
          [[ $1 == "build" ]] && exec ${project-build}/bin/project-build "$2"
          [[ $1 == "run" ]] && exec ${project-run}/bin/project-run "$2"
          [[ $1 == "test" ]] && exec ${project-test}/bin/project-test "$2"

          >&2 echo "Unrecognized command: $1"
          exit 1
        '';
      };
    in
    {
      packages.${system}.default = project;
    };
}

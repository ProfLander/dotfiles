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

      project-clean = pkgs.writeShellApplication {
        name = "project-clean";
        text = ''
          #!/bin/sh

          #echo "project-clean: $*"

          PROJECT_TARGET=$(${project-detect}/bin/project-detect "$1")

          if [[ "$PROJECT_TARGET" == "unknown" ]]
          then
            >&2 echo "Unrecognized project"
            exit 1
          fi

          PROJECT=$(echo "$PROJECT_TARGET" | awk "NR==1")
          TARGET=$(echo "$PROJECT_TARGET" | awk "NR==2")

          [[ $PROJECT == "cargo" ]] && cd "$TARGET" && exec ${pkgs.cargo}/bin/cargo clean
          [[ $PROJECT == "go" ]]    && exec ${pkgs.go}/bin/go clean "$TARGET"
          [[ $PROJECT == "make" ]]  && exec make clean "$TARGET"
          [[ $PROJECT == "just" ]]  && exec ${pkgs.just}/bin/just -d "$TARGET" -f "$TARGET/justfile" clean

          exit 1
        '';
      };

      project-build = pkgs.writeShellApplication {
        name = "project-build";
        text = ''
          #!/bin/sh

          #echo "project-build: $*"

          PROJECT_TARGET=$(${project-detect}/bin/project-detect "$1")

          if [[ "$PROJECT_TARGET" == "unknown" ]]
          then
            >&2 echo "Unrecognized project"
            exit 1
          fi

          PROJECT=$(echo "$PROJECT_TARGET" | awk "NR==1")
          TARGET=$(echo "$PROJECT_TARGET" | awk "NR==2")

          [[ $PROJECT == "cargo" ]] && cd "$TARGET" && exec ${pkgs.cargo}/bin/cargo build
          [[ $PROJECT == "go" ]]    && exec ${pkgs.go}/bin/go build "$TARGET"
          [[ $PROJECT == "make" ]]  && exec make build "$TARGET"
          [[ $PROJECT == "just" ]]  && exec ${pkgs.just}/bin/just -d "$TARGET" -f "$TARGET/justfile" build

          exit 1
        '';
      };

      project-run = pkgs.writeShellApplication {
        name = "project-run";
        text = ''
          #!/bin/sh

          #echo "project-run: $*"

          PROJECT_TARGET=$(${project-detect}/bin/project-detect "$1")
          echo "project-path: $PROJECT_TARGET"

          if [[ "$PROJECT_TARGET" == "unknown" ]]
          then
            echo "Unrecognized project"
            exit 1
          fi

          PROJECT=$(echo "$PROJECT_TARGET" | awk "NR==1")
          echo "project: $PROJECT"

          TARGET=$(echo "$PROJECT_TARGET" | awk "NR==2")
          echo "path: $TARGET"

          [[ $PROJECT == "cargo" ]] && cd "$TARGET" && exec ${pkgs.cargo}/bin/cargo run
          [[ $PROJECT == "go" ]]    && exec ${pkgs.go}/bin/go run "$TARGET"
          [[ $PROJECT == "make" ]]  && exec make run "$TARGET"
          [[ $PROJECT == "just" ]]  && exec ${pkgs.just}/bin/just -d "$TARGET" -f "$TARGET/justfile" run

          exit 1
        '';
      };

      project-test = pkgs.writeShellApplication {
        name = "project-test";
        text = ''
          #!/bin/sh

          #echo "project-test: $*"

          PROJECT_TARGET=$(${project-detect}/bin/project-detect "$1")

          if [[ "$PROJECT_TARGET" == "unknown" ]]
          then
            >&2 echo "Unrecognized project"
            exit 1
          fi

          PROJECT=$(echo "$PROJECT_TARGET" | awk "NR==1")
          TARGET=$(echo "$PROJECT_TARGET" | awk "NR==2")

          [[ $PROJECT == "cargo" ]] && cd "$TARGET" && exec ${pkgs.cargo}/bin/cargo test
          [[ $PROJECT == "go" ]]    && exec ${pkgs.go}/bin/go test "$TARGET"
          [[ $PROJECT == "make" ]]  && exec make test "$TARGET"
          [[ $PROJECT == "just" ]]  && exec ${pkgs.just}/bin/just -d "$TARGET" -f "$TARGET/justfile" test

          exit 1
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

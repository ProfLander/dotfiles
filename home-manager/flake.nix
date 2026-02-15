{
  description = "Lander's Home";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake.url = "git+file:///home/lander/src/niri-flake";
    niri.url = "git+file:///home/lander/src/niri";

    astal.url = "github:aylur/astal";

    ags.url = "github:aylur/ags"; 

    util-getafix.url = ./util/getafix;
    util-project.url = ./util/project;
    util-input-history.url = ./util/input-history;
    util-niri.url = ./util/niri;
    util-obs.url = ./util/obs;
    util-nvim.url = ./util/nvim;
    util-desktop.url = ./util/desktop;
    util-toolchain.url = ./util/toolchain;
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      util-getafix,
      util-project,
      util-input-history,
      niri,
      util-niri,
      util-obs,
      util-nvim,
      util-desktop,
      util-toolchain,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations."lander" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              getafix = util-getafix.packages.${system}.default;
            })
            (final: prev: {
              project = util-project.packages.${system}.default;
            })
            (final: prev: {
              input-history = util-input-history.packages.${system}.default;
            })
            (final: prev: {
              niri = niri.packages.${system}.default;
            })
            (final: prev: util-niri.packages.${system})
            (final: prev: util-obs.packages.${system})
            (final: prev: util-nvim.packages.${system})
            (final: prev: util-desktop.packages.${system})
            (final: prev: {
              duck-repl = util-toolchain.packages.${system}.default;
            })
          ];
        };
        extraSpecialArgs = { inherit inputs; };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];
      };
    };
}

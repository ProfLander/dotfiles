{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    niri-flake.url = "github:ProfLander/niri-flake";
    niri.url = "github:ProfLander/niri";
    #niri.url = "github:YaLTeR/niri";

    secrets.url = "github:ProfLander/secrets";

    util-getafix.url = ../home-manager/util/getafix;
    util-project.url = ../home-manager/util/project;
    util-input-history.url = ../home-manager/util/input-history;
    util-niri.url = ../home-manager/util/niri;
    util-obs.url = ../home-manager/util/obs;
    util-nvim.url = ../home-manager/util/nvim;
    util-desktop.url = ../home-manager/util/desktop;
    util-toolchain.url = ../home-manager/util/toolchain;
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      secrets,
      niri,
      util-niri,
      util-obs,
      util-nvim,
      util-desktop,
      util-toolchain,
      util-getafix,
      util-project,
      util-input-history,
      ...
    }:
    let
      specialArgs = {
        inherit inputs;
        inherit niri;
        inherit util-niri;
        inherit util-obs;
        inherit util-nvim;
        inherit util-desktop;
        inherit util-toolchain;
        inherit util-getafix;
        inherit util-project;
        inherit util-input-history;
      };
    in {
      nixosConfigurations = {
        # Mini PC
        calliope = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            ./hardware/calliope/default.nix
            ./overlays.nix
            secrets.users.lander-desktop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lander = ./home/default.nix;
            }
          ];
        };

        # Desktop
        artemis = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            ./hardware/artemis/default.nix
            ./overlays.nix
            secrets.users.lander-desktop
            #{
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.users.lander = ./home/default.nix;
            #  home.stateVersion = "25.05";
            #}
          ];
        };

        # Server
        aeolus = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hardware/aeolus/default.nix
            secrets.users.lander
          ];
        };
      };
    };
}

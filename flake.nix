{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixcord.url = "github:FlameFlag/nixcord";

    #niri.url = "github:YaLTeR/niri";
    niri.url = "github:ProfLander/niri/scroll-factor";

    secrets.url = "github:ProfLander/secrets";

    util-getafix.url = ./home/util/getafix;
    util-project.url = ./home/util/project;
    util-input-history.url = ./home/util/input-history;
    util-niri.url = ./home/util/niri;
    util-obs.url = ./home/util/obs;
    util-nvim.url = ./home/util/nvim;
    util-desktop.url = ./home/util/desktop;
    util-toolchain.url = ./home/util/toolchain;
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
        inherit secrets;
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
            secrets.users.lander.desktop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lander = ./home/default.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

        # Desktop
        artemis = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            ./hardware/artemis/default.nix
            ./overlays.nix
            secrets.users.lander.desktop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lander = ./home/default.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

        # Server
        aeolus = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./hardware/aeolus/default.nix
            secrets.users.lander.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lander = ./home/minimal.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

        # Raspberry Pi
        theia = nixpkgs.lib.nixosSystem {
          inherit specialArgs;

          modules = [
            ./hardware/theia/default.nix
            secrets.users.lander.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.lander = ./home/minimal.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };
    };
}

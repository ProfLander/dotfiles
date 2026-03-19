{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nix-gaming.url = "github:fufexan/nix-gaming";

    niri-flake.url = "github:ProfLander/niri-flake";
    niri.url = "github:ProfLander/niri";
    #niri.url = "github:YaLTeR/niri";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    secrets.url = "github:ProfLander/secrets";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      secrets,
      ...
    }:
    {
      nixosConfigurations = {
        # Mini PC
        calliope = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware/calliope/default.nix
            secrets.users.lander-desktop
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

        # Desktop
        artemis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware/artemis/default.nix
            secrets.users.lander-desktop
          ];
        };

        # Server
        aeolus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hardware/aeolus/default.nix
            secrets.users.lander
          ];
        };
      };
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-gaming.url = "github:fufexan/nix-gaming";
    niri-flake.url = "github:ProfLander/niri-flake";
    niri.url = "github:ProfLander/niri";
    #niri.url = "github:YaLTeR/niri";
  };
  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations = {
        # Desktop
        artemis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hardware/artemis/default.nix ];
        };

        # Server
        aeolus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hardware/aeolus/default.nix ];
        };
      };
    };
}

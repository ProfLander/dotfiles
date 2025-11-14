{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-gaming.url = "github:fufexan/nix-gaming";
    niri.url = "github:sodiboo/niri-flake";
  };
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [ ./configuration.nix ];
    };
  };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-gaming.url = "github:fufexan/nix-gaming";
    niri-flake.url = "git+file:///home/lander/src/niri-flake";
    niri.url = "git+file:///home/lander/src/niri";
    #niri.url = "github:YaLTeR/niri";
  };
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [ ./configuration.nix ];
    };
  };
}

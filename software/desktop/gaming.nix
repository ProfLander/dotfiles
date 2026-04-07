{ inputs, ... }:

{
  # Game mode
  programs.gamemode.enable = true;

  # Enable Cachix for nix-gaming
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # SteamOS platform optimizations
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs.steam.platformOptimizations.enable = true;
  services.input-remapper.enable = true;
}

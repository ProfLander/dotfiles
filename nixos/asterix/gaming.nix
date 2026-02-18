{ pkgs, inputs, ... }:

{
  # Game mode
  programs.gamemode.enable = true;

  # SteamOS platform optimizations
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  programs.steam.platformOptimizations.enable = true;
  services.input-remapper.enable = true;
}

{ pkgs, inputs, ... }:

{
  # Use Wine-TKG to run windows programs
  imports = [
      inputs.nix-gaming.nixosModules.wine
  ];

  programs.wine = {
    enable = true;
    package = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
    ntsync = true;
  };
}

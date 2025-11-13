{ pkgs, inputs, ... }:

{
  # Use Wine-TKG to run windows programs
  imports = [
      inputs.nix-gaming.nixosModules.wine
  ];

  programs.wine = {
    enable = true;
    package = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
    ntsync = true;
  };
}

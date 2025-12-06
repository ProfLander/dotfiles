
{ pkgs, ... }:

{
  imports = [
    ./cpp.nix
    ./nix.nix
    ./rust.nix
    ./fennel.nix
  ];
}

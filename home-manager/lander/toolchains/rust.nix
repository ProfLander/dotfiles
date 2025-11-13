{ pkgs, ... }:

{
  home.packages = [
    pkgs.cargo
    pkgs.rust-analyzer
  ];
}

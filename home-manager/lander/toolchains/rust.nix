{ pkgs, ... }:

{
  home.packages = [
    pkgs.cargo
    pkgs.rustfmt
    pkgs.rust-analyzer
  ];
}

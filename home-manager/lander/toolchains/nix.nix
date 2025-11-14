{ pkgs, ... }:

{
  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
  ];
}

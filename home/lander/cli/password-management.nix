{ pkgs, ... }:

{
  home.packages = [
    pkgs.pinentry-all
    pkgs.pass
  ];
}

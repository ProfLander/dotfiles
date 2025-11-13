{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.pinentry-all
    pkgs.pass
  ];
}

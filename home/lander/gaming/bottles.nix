{ pkgs, ... }:

{
  home.packages = [
    (pkgs.bottles.override { removeWarningPopup = true; })
  ];
}
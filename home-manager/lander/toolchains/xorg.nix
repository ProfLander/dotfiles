{ pkgs, ... }:
{
  home.packages = [
    pkgs.xorg.libX11.dev
    pkgs.xorg.libXi
    pkgs.xorg.libXtst
    pkgs.libxkbcommon
  ];
}

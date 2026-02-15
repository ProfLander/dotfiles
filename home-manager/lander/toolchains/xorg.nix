{ pkgs, ... }:
{
  home.packages = [
    pkgs.libx11.dev
    pkgs.libxi
    pkgs.libxtst
    pkgs.libxkbcommon
  ];
}

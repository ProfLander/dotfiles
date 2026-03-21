{ pkgs, ... }:
{
  home.packages = [
    pkgs.luajit
    pkgs.lua-language-server
  ];
}

{ pkgs, ... }:

{
  home.packages = [
    pkgs.love
    pkgs.duck-repl
  ];
}

{ pkgs, ... }:

{
  home.packages = [
    pkgs.fd
    pkgs.fzf
    pkgs.ripgrep
  ];
}

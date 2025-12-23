{ pkgs, ... }:

{
  home.packages = [
    pkgs.curl
    pkgs.rsync
  ];
}

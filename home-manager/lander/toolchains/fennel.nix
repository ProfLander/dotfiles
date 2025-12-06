{ pkgs, ... }:

{
  home.packages = [
    pkgs.luaPackages.fennel
    pkgs.fennel-ls
  ];
}

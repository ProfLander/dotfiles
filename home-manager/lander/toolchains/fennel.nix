{ pkgs, ... }:

{
  home.packages = [
    pkgs.luajitPackages.fennel
    pkgs.luajitPackages.readline
    pkgs.fennel-ls
    pkgs.fnlfmt
  ];

  home.file.".fennelrc".source = ./fennelrc.fnl;
  home.file.".inputrc".source = ./inputrc;
}

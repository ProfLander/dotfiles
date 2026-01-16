{ pkgs, ... }:

{
  home.packages = [
    pkgs.luajitPackages.fennel
    pkgs.fennel-ls
    pkgs.fnlfmt
  ];

  home.file.".fennelrc".source = ./fennelrc.fnl;
  home.file.".inputrc".source = ./inputrc;
}

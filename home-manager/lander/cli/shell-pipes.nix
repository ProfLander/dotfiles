{ pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.jc
    pkgs.jq
    pkgs.fzf
  ];
}

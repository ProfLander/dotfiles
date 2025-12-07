{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "master";
      };
      user = {
        name = "Prof. Lander";
        email = "1253239+ProfLander@users.noreply.github.com";
      };
    };
  };

  home.packages = [
    pkgs.gitu
  ];
}

{ pkgs, ... }:

{
  users.users.lander = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "render"
      "video"
    ];
    shell = pkgs.zsh;
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "lander";
}

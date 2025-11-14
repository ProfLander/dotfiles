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

  # Automatic TTY login
  services.mingetty.autologinUser = "lander";
}

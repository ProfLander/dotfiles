{ pkgs, ... }:

{
  users.users.lander = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "gamemode"
      "render"
      "input"
      "video"
    ];
    shell = pkgs.zsh;
  };

  # Automatic TTY login
  services.getty.autologinUser = "lander";

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        "/run/current-system/sw/bin/shutdown"
        "/run/current-system/sw/bin/reboot"
      ];
    }
  ]; 
}

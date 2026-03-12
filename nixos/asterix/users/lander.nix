{ pkgs, ... }:

{
  users.users.lander = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

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

{
  users.users.lander = {
    extraGroups = [
      "gamemode"
      "render"
      "input"
      "video"
    ];
  };

  # Automatic TTY login
  services.getty.autologinUser = "lander";
}

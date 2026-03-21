{
  services.openssh = {
    enable = true;
    ports = [ 65513 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "lander" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };
}

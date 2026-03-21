{
  services.transmission = {
    enable = true;
    settings = {
      rpc-bind-address = "0.0.0.0"; # Allows access from other devices
      rpc-port = 9091;
      rpc-authentication-required = false;
      rpc-whitelist = "*";
    };
  };

  # Open firewall ports
  networking.firewall.allowedTCPPorts = [ 9091 51413 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}

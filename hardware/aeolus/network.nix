{
  networking = {
    hostName = "aeolus";

    useDHCP = false;

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];

    interfaces = {
      enp2s0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.2";
            prefixLength = 24;
          }
        ];

        wakeOnLan.enable = true;
      };
    };

    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
}

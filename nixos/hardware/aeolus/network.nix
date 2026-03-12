{
  networking = {
    hostName = "aeolus";
    useDHCP = false;

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

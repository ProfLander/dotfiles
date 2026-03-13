{
  networking = {
    hostName = "calliope";

    useDHCP = false;

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];

    interfaces = {
      enp2s0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.4";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}

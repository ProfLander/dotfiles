{
  networking = {
    hostName = "artemis";

    useDHCP = false;

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];

    interfaces = {
      enp6s0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.3";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}

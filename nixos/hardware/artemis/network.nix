{ lib, ... }:

{
  networking = {
    hostName = "artemis";
    useDHCP = false;

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

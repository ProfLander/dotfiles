{ lib, ... }:

{
  networking = {
    hostName = "aeolus";
    useDHCP = lib.mkDefault true;

    interfaces = {
      enp2s0 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
}

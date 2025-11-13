{ lib, ... }:

{
  networking.hostName = "artemis";
  networking.useDHCP = lib.mkDefault true;
}

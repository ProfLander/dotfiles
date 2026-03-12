{ lib, ... }:

{
  networking.hostName = "aeolus";
  networking.useDHCP = lib.mkDefault true;
}

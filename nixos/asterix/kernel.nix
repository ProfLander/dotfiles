{ pkgs, ... }:

{
  # Use XanMod-Stable for gaming optimizations
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
}

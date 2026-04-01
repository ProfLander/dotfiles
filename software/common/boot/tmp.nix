{
  boot.tmp.useTmpfs = true;
  boot.tmp.cleanOnBoot = true;

  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}

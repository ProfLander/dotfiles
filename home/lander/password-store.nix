{ lib, stdenv, secrets, ... }:
{
  home.file.".password-store".source = secrets.password-store {
    inherit lib;
    inherit stdenv;
  };
}

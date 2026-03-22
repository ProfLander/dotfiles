{ pkgs, ... }:

let
  stdenv = pkgs.stdenv;
  fetchFromGitHub = pkgs.fetchFromGitHub;

  mac-tahoe = stdenv.mkDerivation rec {
    pname = "MacTahoe-Dark";
    version = "a678d53eb070823df724fd8a6fac502106a4702d";
    dontBuild = true;

    src = fetchFromGitHub {
      owner = "ProfLander";
      repo = "MacTahoe-gtk-theme";
      rev = "${version}";
      sha256 = "sha256-NdKeI4q1M3Z9DGJy73n4okjk6W7Qru0E1Ka0C6bmyko=";
    };

    installPhase = ''
      tar -xvf $src/release/${pname}.tar.xz
      mkdir -p $out/share/themes
      cp -aR ${pname} $out/share/themes/${pname}
    '';
  };
in {
  # Use GTK3 for color / emoji / file pickers
  environment.systemPackages = [
    pkgs.gtk3
    mac-tahoe
  ];

  # Override the GSettings schema dir to point at gtk3
  # Works around https://github.com/NixOS/nixpkgs/issues/154150
  environment.sessionVariables = {
    GSETTINGS_SCHEMA_DIR =
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
  };
}

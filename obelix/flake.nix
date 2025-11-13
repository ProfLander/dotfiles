{
  description = "Obelix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ags,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pname = "obelix";
    entry = "app.tsx";

    astalPackages = with ags.packages.${system}; [
      io
      astal4 # or astal3 for gtk3
      apps
      notifd
      tray
      # wireplumber
    ];

    extraPackages =
      astalPackages
      ++ [
        # AGS
        pkgs.libadwaita
        pkgs.libsoup_3
        
        # Shell
        pkgs.jc
        pkgs.fzf
        pkgs.rocmPackages.rocm-smi
        pkgs.rocmPackages.amdsmi
        
        # Need to move these into a config to break package semantic
        pkgs.firefox
        pkgs.alacritty
        pkgs.zsh
      ];
  in {
    packages.${system} = {
      default = pkgs.stdenv.mkDerivation {
        name = pname;
        src = ./.;

        nativeBuildInputs = with pkgs; [
          wrapGAppsHook3
          gobject-introspection
          ags.packages.${system}.default
        ];

        buildInputs = extraPackages ++ [pkgs.gjs];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          mkdir -p $out/share
          cp -r * $out/share
          ls -al
          ags bundle ${entry} $out/bin/${pname} -d "SRC='$out/share'"

          runHook postInstall
        '';
      };
    };

    devShells.${system} = {
      default = pkgs.mkShell {
        buildInputs = [
          (ags.packages.${system}.default.override {
            inherit extraPackages;
          })
        ];
      };
    };
  };
}

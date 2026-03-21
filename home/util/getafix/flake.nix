{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      quickshell,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      getafix-config = pkgs.stdenv.mkDerivation {
        name = "getafix-config";
        src = ./src;
        installPhase = ''
          mkdir -p $out
          cp -r . $out/
        '';
      };
      getafix = pkgs.writeShellApplication {
        name = "getafix";

        # Ensure quickshell and required Qt dependencies are available at runtime
        runtimeInputs = [
          pkgs.quickshell
          pkgs.qt6.qtwayland
        ];

        text = ''
          # Run quickshell pointing to the path in the Nix store
          # Use -p/--path to specify the entry point
          quickshell --path "${getafix-config}" "$@"
        '';
      };

      dev-shell = {
        default = pkgs.mkShell {
          buildInputs = [
            quickshell.packages.${system}.default
          ];
        };
      };
    in
    {
      # 2. Package the runner using writeShellApplication
      packages.${system}.default = getafix;

      devShells.${system} = dev-shell;
    };
}

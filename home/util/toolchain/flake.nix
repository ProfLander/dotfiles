{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      duck-repl = pkgs.writeShellApplication {
        name = "duck-repl";
        runtimeInputs = [
          pkgs.love
        ];

        derivationArgs = {
          propagatedBuildInputs = [ pkgs.love ];
        };

        text = ''
          #!/bin/sh
          cd /home/lander/src/project-dungeon
          ${pkgs.love}/bin/love . --repl
        '';
      };
    in
    {
      packages.${system}.default = duck-repl;
    };
}

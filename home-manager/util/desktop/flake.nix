{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      graphical-unit = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };

      graphical-service = {
        Restart = "always";
      };

      graphical-install = {
        WantedBy = [ "graphical-session.target" ];
      };

      graphical-program = { desc, exec-start }: {
        Unit = graphical-unit // {
          Description = desc;
        };

        Service = graphical-service // {
          ExecStart = exec-start;
        };

        Install = graphical-install;
      };

      desktop-run = pkgs.writeShellApplication {
        name = "desktop-run";
        text = ''
          l() {
            p="''${XDG_DATA_HOME:-$HOME/.local/share}:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:"
            while [ -n "$p" ]; do
              d="''${p%%:*}"; p="''${p#*:}"
              case "$d" in */applications|*/applications/) s="$d" ;; *) s="$d/applications" ;; esac
              [ -d "$s" ] && ${pkgs.findutils}/bin/find -L "$s" -maxdepth 1 -name "*.desktop" -type f 2>/dev/null
            done | while read -r f; do
              printf "%s\t%s\n" "$(${pkgs.gnused}/bin/sed -n 's/^Name=//p' "$f" | head -1)" "$f"
            done
          }

          sel=$(l | sort -f | ${pkgs.fzf}/bin/fzf --with-nth=1 --delimiter='\t')
          [ -n "$sel" ] && {
            cmd=$(${pkgs.gnused}/bin/sed -n 's/^Exec=//p' "$(printf "%s" "$sel" | cut -f2)" | head -1 | ${pkgs.gnused}/bin/sed 's/%[fFuUikv]//g;s/^[ ]*//;s/[ ]*$//')
            ${pkgs.systemd}/bin/systemd-run --user --slice=app.slice --collect -- "$cmd"
          }
        '';
      };
    in
    {
      packages.${system} = {
        graphical-program = graphical-program;
        desktop-run = desktop-run;
      };
    };
}

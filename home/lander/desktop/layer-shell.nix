{ pkgs, ... }:
{
  home.packages = [ pkgs.getafix ];
  systemd.user.services.getafix = {
    Unit = {
      Description = "Layer shell";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };

    Service = {
      ExecStart = "${pkgs.getafix}/bin/getafix";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

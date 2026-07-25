{
  pkgs,
  ...
}:
let
  arrange-layout-bin = "${pkgs.arrange-layout}/bin/arrange-layout";
in
{
  home.packages = [
    pkgs.app-id-to-niri-id
    pkgs.desktop-run
  ];

  systemd.user.services.arrange-layout = {
    Unit = {
      Description = "Arrange layout";
      Requisite = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };

    Service = {
      ExecStart = "${arrange-layout-bin}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.sessionVariables = {
    # Session info
    XDG_SESSION_TYPE = "wayland";

    # GTK
    GDK_SCALE = 2;
    GTK_THEME = "MacTahoe-Dark";
    GTK2_RC_FILES = "~/.themes/MacTahoe-Dark/gtk-2.0/gtkrc";

    # Qt

    ## Enable high-DPI
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_ENABLE_HIGHDPI_SCALING = 1;

    ## Prevent font aliasing in high-DPI Qt6 programs
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";

    ## Force wayland as the first choice of backend
    QT_QPA_PLATFORM = "wayland:xcb";

    ## Don't draw window decorations
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # Enable Ozone Wayland support in Chrome and Electron
    NIXOS_OZONE_WL = "1";
  };
}

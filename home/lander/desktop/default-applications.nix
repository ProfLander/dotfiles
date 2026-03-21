{ pkgs, ... }:
{
  xdg.desktopEntries = {
    neovide = {
      name = "Neovide";
      genericName = "Text Editor";
      exec = "${pkgs.run-neovide}/bin/run-neovide %U";
      terminal = false;
      icon = "nvim";
    };
    firefox-work = {
      name = "Firefox (Work)";
      exec = "firefox -P Work %U";
      terminal = false;
      icon = "firefox";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = "neovide.desktop";
      "application/toml" = "neovide.desktop";
      "application/x-shellscript" = "neovide.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml" = "firefox.desktop";
      "image/webp" = "firefox.desktop";

      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}

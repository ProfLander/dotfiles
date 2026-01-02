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
      "text/plain" = "neovide.desktop";
      "text/x-lua" = "neovide.desktop";
      "text/x-qml" = "neovide.desktop";
      "text/markdown" = "neovide.desktop";
      "text/rust" = "neovide.desktop";
      "application/toml" = "neovide.desktop";
      "application/x-shellscript" = "neovide.desktop";
      "text/html" = "neovide.desktop";
      "text/css" = "neovide.desktop";
      "text/org" = "neovide.desktop";

      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml" = "firefox.desktop";
      "image/webp" = "firefox.desktop";

      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}

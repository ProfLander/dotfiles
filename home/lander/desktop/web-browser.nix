{ pkgs, ... }:

### MANUAL FIREFOX CONFIGURATION:
## UI
# Right click next to title bar, enable vertical tabs
# Dismiss vertical tab info segment
# Collapse vertical tabs
#
## about:config
# WaveFox.Linux.Transparency.Enabled = true
# WaveFox.WebPage.Transparency = 2;
# WaveFox.WebPage.Background.Saturation = 3;
# WaveFox.Toolbar.Roundings = 2;
#
## Tridactyl
# :set newtab about:blank
# Open new tab, select Keep Changes in popup

let
  firefox-wavefox-theme = builtins.fetchGit {
    url = "https://github.com/QNetITQ/WaveFox.git";
    rev = "57fa6edfe6112dddf21633e63b9b80847428b7a5";
  };

  wavefox-chrome = ''
    @import "../../wavefox/chrome/userChrome.css";

    #urlbar-background,#urlbar {
        border-radius: 32px !important;
    }
  '';

  wavefox-content = ''
    @import "../../wavefox/chrome/userContent.css";
  '';

  mkProfile =
    input:
    input
    // {
      userChrome = wavefox-chrome;
      userContent = wavefox-content;
    };

  mkLocked = value: {
    Value = value;
    Status = "locked";
  };

  lock-false = mkLocked false;
  lock-true = mkLocked true;
  lock-1 = mkLocked 1;
  lock-2 = mkLocked 2;
  lock-3 = mkLocked 3;

  firefox = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    extraPolicies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        # blocks all addons except the ones specified below
        "*".installation_mode = "blocked";

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4549492/tridactyl_vim-1.24.4.xpi";
          installation_mode = "force_installed";
        };

        # I Don't Care About Cookies
        "jid1-KKzOGWgsW3Ao4Q@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4202634/i_dont_care_about_cookies-3.5.0.xpi";
          installation_mode = "force_installed";
        };
      };

      # ---- PREFERENCES ----
      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "browser.tabs.inTitlebar" = lock-1;
        "browser.tabs.allow_transparent_browser" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.startup.page" = lock-3;
        "browser.startup.homepage" = mkLocked "about:blank";
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;

        # Enable user chrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;
      };
    };
  };

  firefox-run =
    { name, profile }:
    ''
      ${firefox}/bin/firefox --name ${name} --no-remote -P ${profile}
    '';

  graphical-program = pkgs.graphical-program;
in
{
  # Environment setup
  home.file.".mozilla/firefox/wavefox".source = firefox-wavefox-theme;

  home.sessionVariables = {
    BROWSER = "${firefox}/bin/firefox --new-window";
  };

  # Firefox configuration
  programs.firefox = {
    enable = true;

    package = firefox;

      profiles = {
        default = mkProfile {
          name = "Default";
          isDefault = true;
          id = 0;
        };

        work = mkProfile {
          name = "Work";
          id = 1;
        };

        media = mkProfile {
          name = "Media";
          id = 2;
        };

        chat = mkProfile {
          name = "Chat";
          id = 3;
        };
      };
  };

  # Services
  systemd.user.services.chat-browser = graphical-program {
    desc = "Chat browser";
    exec-start = firefox-run {
      name = "chat-browser";
      profile = "Chat";
    };
  };

  systemd.user.services.media-web-browser = graphical-program {
    desc = "Media web browser";
    exec-start = firefox-run {name = "media-web-browser"; profile = "Media";};
  };

  systemd.user.services.work-browser = graphical-program {
    desc = "Work browser";
    exec-start = (
      firefox-run {
        name = "work-browser";
        profile = "Work";
      }
    );
  };

  systemd.user.services.main-browser = graphical-program {
    desc = "Main browser";
    exec-start = firefox-run { name = "main-browser"; profile = "Default";};
  };
}

{ inputs, pkgs, ... }:

### MANUAL VESKTOP CONFIG
## UI
# Settings -> Vesktop Settings -> Turn off Enable Splash Screen, Splash Theming
# Settings -> Streamer Mode -> Turn off Enable Streamer Mode, Automatically enable...

{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;

    vesktop.enable = true;

    config = {
      frameless = true;
      autoUpdate = true;
      autoUpdateNotification = true;
      useQuickCss = true;
      transparent = true;

      themes = {
        "TranslucencePlus.theme" = ./TranslucencePlus.theme.css;
        "RemoveButtons.patch" = ./RemoveButtons.patch.css;
        "RemoveTitlebar.patch" = ./RemoveTitlebar.patch.css;
        "HighlightColor.patch" = ./HighlightColor.patch.css;
      };

      enabledThemes = [
        "TranslucencePlus.theme.css"
        "RemoveButtons.patch.css"
        "RemoveTitlebar.patch.css"
        "HighlightColor.patch.css"
      ];

      plugins = {
        alwaysTrust.enable = true;
        disableDeepLinks.enable = true;
        fakeNitro = {
          enable = true;
          enableEmojiBypass = true;
          enableStickerBypass = true;
          enableStreamQualityBypass = true;
          transformEmojis = true;
          transformStickers = true;
          transformCompoundSentence = true;
        };
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        gameActivityToggle.enable = true;
        ircColors.enable = true;
        mentionAvatars.enable = true;
        messageLogger.enable = true;
        #messageLoggerEnhanced.enable = true;
        noBlockedMessages.enable = true;
        noOnboardingDelay.enable = true;
        noTypingAnimation.enable = true;
        showMeYourName.enable = true;
        streamerModeOnStream.enable = false;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        webContextMenus.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };

  systemd.user.services.vesktop = {
    Unit = {
      Description = "Discord client";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };

    Service = {
      ExecStart = "${pkgs.vesktop}/bin/vesktop";
      KillSignal = "SIGKILL";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

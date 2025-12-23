{ pkgs, ... }:
{
  programs.vesktop = {
    enable = true;

    settings = {
      discordBranch = "stable";
      minimizeToTray = false;
      arRPC = true;
      splashColor = "rgb(223, 224, 226)";
      splashBackground = "rgba(0, 0, 0, 0)";
      hardwareVideoAcceleration = false;
      enableSplashScreen = false;
      tray = false;
      spellCheckLanguages = [
          "en-GB"
          "en"
      ];
    };

    vencord = {
      themes = { 
        "TranslucencePlus.theme" = ./TranslucencePlus.theme.css;
        "RemoveButtons.patch" = ./RemoveButtons.patch.css;
        "RemoveTitlebar.patch" = ./RemoveTitlebar.patch.css;
        "HighlightColor.patch" = ./HighlightColor.patch.css;
      };

      settings = {
        "autoUpdate" = true;
        "autoUpdateNotification" = true;
        "useQuickCss" = true;
        "themeLinks" = [];
        "eagerPatches" = false;
        "enabledThemes" = [
          "TranslucencePlus.theme.css"
          "RemoveButtons.patch.css"
          "RemoveTitlebar.patch.css"
          "HighlightColor.patch.css"
        ];
        "enableReactDevtools" = false;
        "frameless" = true;
        "transparent" = true;
        "winCtrlQ" = false;
        "disableMinSize" = false;
        "winNativeTitleBar" = false;
        "plugins" = {
          "ChatInputButtonAPI" = {
            "enabled" = false;
          };
          "CommandsAPI" = {
            "enabled" = true;
          };
          "DynamicImageModalAPI" = {
            "enabled" = false;
          };
          "MemberListDecoratorsAPI" = {
            "enabled" = false;
          };
          "MessageAccessoriesAPI" = {
            "enabled" = true;
          };
          "MessageDecorationsAPI" = {
            "enabled" = false;
          };
          "MessageEventsAPI" = {
            "enabled" = true;
          };
          "MessagePopoverAPI" = {
            "enabled" = false;
          };
          "MessageUpdaterAPI" = {
            "enabled" = true;
          };
          "ServerListAPI" = {
            "enabled" = false;
          };
          "UserSettingsAPI" = {
            "enabled" = true;
          };
          "AccountPanelServerProfile" = {
            "enabled" = false;
          };
          "AlwaysAnimate" = {
            "enabled" = false;
          };
          "AlwaysExpandRoles" = {
            "enabled" = false;
          };
          "AlwaysTrust" = {
            "enabled" = true;
            "domain" = true;
            "file" = true;
          };
          "AnonymiseFileNames" = {
            "enabled" = false;
          };
          "AppleMusicRichPresence" = {
            "enabled" = false;
          };
          "WebRichPresence (arRPC)" = {
            "enabled" = false;
          };
          "BetterFolders" = {
            "enabled" = false;
          };
          "BetterGifAltText" = {
            "enabled" = false;
          };
          "BetterGifPicker" = {
            "enabled" = false;
          };
          "BetterNotesBox" = {
            "enabled" = false;
          };
          "BetterRoleContext" = {
            "enabled" = false;
          };
          "BetterRoleDot" = {
            "enabled" = false;
          };
          "BetterSessions" = {
            "enabled" = false;
          };
          "BetterSettings" = {
            "enabled" = false;
          };
          "BetterUploadButton" = {
            "enabled" = false;
          };
          "BiggerStreamPreview" = {
            "enabled" = false;
          };
          "BlurNSFW" = {
            "enabled" = false;
          };
          "CallTimer" = {
            "enabled" = false;
          };
          "ClearURLs" = {
            "enabled" = false;
          };
          "ClientTheme" = {
            "enabled" = false;
          };
          "ColorSighted" = {
            "enabled" = false;
          };
          "ConsoleJanitor" = {
            "enabled" = false;
          };
          "ConsoleShortcuts" = {
            "enabled" = false;
          };
          "CopyEmojiMarkdown" = {
            "enabled" = false;
          };
          "CopyFileContents" = {
            "enabled" = false;
          };
          "CopyStickerLinks" = {
            "enabled" = false;
          };
          "CopyUserURLs" = {
            "enabled" = false;
          };
          "CrashHandler" = {
            "enabled" = true;
          };
          "CtrlEnterSend" = {
            "enabled" = false;
          };
          "CustomIdle" = {
            "enabled" = false;
          };
          "CustomRPC" = {
            "enabled" = false;
          };
          "Dearrow" = {
            "enabled" = false;
          };
          "Decor" = {
            "enabled" = false;
          };
          "DisableCallIdle" = {
            "enabled" = false;
          };
          "DontRoundMyTimestamps" = {
            "enabled" = false;
          };
          "Experiments" = {
            "enabled" = false;
          };
          "ExpressionCloner" = {
            "enabled" = false;
          };
          "F8Break" = {
            "enabled" = false;
          };
          "FakeNitro" = {
            "enabled" = true;
            "enableStickerBypass" = true;
            "enableStreamQualityBypass" = true;
            "enableEmojiBypass" = true;
            "transformEmojis" = true;
            "transformStickers" = true;
            "transformCompoundSentence" = false;
            "emojiSize" = 48;
            "hyperLinkText" = "{{NAME}}";
            "useHyperLinks" = true;
            "disableEmbedPermissionCheck" = false;
          };
          "FakeProfileThemes" = {
            "enabled" = false;
          };
          "FavoriteEmojiFirst" = {
            "enabled" = false;
          };
          "FavoriteGifSearch" = {
            "enabled" = false;
          };
          "FixCodeblockGap" = {
            "enabled" = false;
          };
          "FixImagesQuality" = {
            "enabled" = true;
          };
          "FixSpotifyEmbeds" = {
            "enabled" = true;
          };
          "FixYoutubeEmbeds" = {
            "enabled" = true;
          };
          "ForceOwnerCrown" = {
            "enabled" = false;
          };
          "FriendInvites" = {
            "enabled" = false;
          };
          "FriendsSince" = {
            "enabled" = false;
          };
          "FullSearchContext" = {
            "enabled" = false;
          };
          "FullUserInChatbox" = {
            "enabled" = false;
          };
          "GameActivityToggle" = {
            "enabled" = true;
            "oldIcon" = false;
          };
          "GifPaste" = {
            "enabled" = false;
          };
          "GreetStickerPicker" = {
            "enabled" = false;
          };
          "HideMedia" = {
            "enabled" = false;
          };
          "iLoveSpam" = {
            "enabled" = false;
          };
          "IgnoreActivities" = {
            "enabled" = false;
          };
          "ImageFilename" = {
            "enabled" = false;
          };
          "ImageLink" = {
            "enabled" = false;
          };
          "ImageZoom" = {
            "enabled" = false;
          };
          "ImplicitRelationships" = {
            "enabled" = false;
          };
          "InvisibleChat" = {
            "enabled" = false;
          };
          "IrcColors" = {
            "enabled" = true;
            "memberListColors" = true;
            "lightness" = 70;
            "applyColorOnlyInDms" = false;
            "applyColorOnlyToUsersWithoutColor" = false;
          };
          "KeepCurrentChannel" = {
            "enabled" = false;
          };
          "LastFMRichPresence" = {
            "enabled" = false;
          };
          "LoadingQuotes" = {
            "enabled" = false;
          };
          "MemberCount" = {
            "enabled" = false;
          };
          "MentionAvatars" = {
            "enabled" = true;
            "showAtSymbol" = true;
          };
          "MessageClickActions" = {
            "enabled" = false;
          };
          "MessageLatency" = {
            "enabled" = false;
          };
          "MessageLinkEmbeds" = {
            "enabled" = false;
          };
          "MessageLogger" = {
            "enabled" = true;
            "collapseDeleted" = false;
            "deleteStyle" = "text";
            "ignoreBots" = false;
            "ignoreSelf" = false;
            "ignoreUsers" = "";
            "ignoreChannels" = "";
            "ignoreGuilds" = "";
            "logEdits" = true;
            "logDeletes" = true;
            "inlineEdits" = true;
          };
          "MessageTags" = {
            "enabled" = false;
          };
          "MutualGroupDMs" = {
            "enabled" = false;
          };
          "NewGuildSettings" = {
            "enabled" = false;
          };
          "NoBlockedMessages" = {
            "enabled" = true;
          };
          "NoDevtoolsWarning" = {
            "enabled" = false;
          };
          "NoF1" = {
            "enabled" = false;
          };
          "NoMaskedUrlPaste" = {
            "enabled" = false;
          };
          "NoMosaic" = {
            "enabled" = false;
          };
          "NoOnboardingDelay" = {
            "enabled" = true;
          };
          "NoPendingCount" = {
            "enabled" = false;
          };
          "NoProfileThemes" = {
            "enabled" = false;
          };
          "NoReplyMention" = {
            "enabled" = false;
          };
          "NoServerEmojis" = {
            "enabled" = false;
          };
          "NoTypingAnimation" = {
            "enabled" = true;
          };
          "NoUnblockToJump" = {
            "enabled" = false;
          };
          "NormalizeMessageLinks" = {
            "enabled" = false;
          };
          "NotificationVolume" = {
            "enabled" = false;
          };
          "OnePingPerDM" = {
            "enabled" = false;
          };
          "oneko" = {
            "enabled" = false;
          };
          "OpenInApp" = {
            "enabled" = false;
          };
          "OverrideForumDefaults" = {
            "enabled" = false;
          };
          "PauseInvitesForever" = {
            "enabled" = false;
          };
          "PermissionFreeWill" = {
            "enabled" = false;
          };
          "PermissionsViewer" = {
            "enabled" = false;
          };
          "petpet" = {
            "enabled" = false;
          };
          "PictureInPicture" = {
            "enabled" = false;
          };
          "PinDMs" = {
            "enabled" = false;
          };
          "PlainFolderIcon" = {
            "enabled" = false;
          };
          "PlatformIndicators" = {
            "enabled" = false;
          };
          "PreviewMessage" = {
            "enabled" = false;
          };
          "QuickMention" = {
            "enabled" = false;
          };
          "QuickReply" = {
            "enabled" = false;
          };
          "ReactErrorDecoder" = {
            "enabled" = false;
          };
          "ReadAllNotificationsButton" = {
            "enabled" = false;
          };
          "RelationshipNotifier" = {
            "enabled" = false;
          };
          "ReplaceGoogleSearch" = {
            "enabled" = false;
          };
          "ReplyTimestamp" = {
            "enabled" = false;
          };
          "RevealAllSpoilers" = {
            "enabled" = false;
          };
          "ReverseImageSearch" = {
            "enabled" = false;
          };
          "ReviewDB" = {
            "enabled" = false;
          };
          "RoleColorEverywhere" = {
            "enabled" = false;
          };
          "SecretRingToneEnabler" = {
            "enabled" = false;
          };
          "Summaries" = {
            "enabled" = false;
          };
          "SendTimestamps" = {
            "enabled" = false;
          };
          "ServerInfo" = {
            "enabled" = false;
          };
          "ServerListIndicators" = {
            "enabled" = false;
          };
          "ShikiCodeblocks" = {
            "enabled" = false;
          };
          "ShowAllMessageButtons" = {
            "enabled" = false;
          };
          "ShowConnections" = {
            "enabled" = false;
          };
          "ShowHiddenChannels" = {
            "enabled" = false;
          };
          "ShowHiddenThings" = {
            "enabled" = false;
          };
          "ShowMeYourName" = {
            "enabled" = true;
            "mode" = "user-nick";
            "friendNicknames" = "dms";
            "displayNames" = false;
            "inReplies" = false;
          };
          "ShowTimeoutDuration" = {
            "enabled" = false;
          };
          "SilentMessageToggle" = {
            "enabled" = false;
          };
          "SilentTyping" = {
            "enabled" = false;
          };
          "SortFriendRequests" = {
            "enabled" = false;
          };
          "SpotifyControls" = {
            "enabled" = false;
          };
          "SpotifyCrack" = {
            "enabled" = false;
          };
          "SpotifyShareCommands" = {
            "enabled" = false;
          };
          "StartupTimings" = {
            "enabled" = false;
          };
          "StickerPaste" = {
            "enabled" = false;
          };
          "StreamerModeOnStream" = {
            "enabled" = false;
          };
          "SuperReactionTweaks" = {
            "enabled" = false;
          };
          "TextReplace" = {
            "enabled" = false;
          };
          "ThemeAttributes" = {
            "enabled" = false;
          };
          "Translate" = {
            "enabled" = false;
          };
          "TypingIndicator" = {
            "enabled" = true;
          };
          "TypingTweaks" = {
            "enabled" = true;
          };
          "Unindent" = {
            "enabled" = false;
          };
          "UnlockedAvatarZoom" = {
            "enabled" = false;
          };
          "UnsuppressEmbeds" = {
            "enabled" = false;
          };
          "UserMessagesPronouns" = {
            "enabled" = false;
          };
          "UserVoiceShow" = {
            "enabled" = false;
          };
          "USRBG" = {
            "enabled" = false;
          };
          "ValidReply" = {
            "enabled" = false;
          };
          "ValidUser" = {
            "enabled" = false;
          };
          "VoiceChatDoubleClick" = {
            "enabled" = false;
          };
          "VcNarrator" = {
            "enabled" = false;
          };
          "VencordToolbox" = {
            "enabled" = false;
          };
          "ViewIcons" = {
            "enabled" = false;
          };
          "ViewRaw" = {
            "enabled" = false;
          };
          "VoiceDownload" = {
            "enabled" = false;
          };
          "VoiceMessages" = {
            "enabled" = false;
          };
          "VolumeBooster" = {
            "enabled" = false;
          };
          "WebKeybinds" = {
            "enabled" = true;
          };
          "WebScreenShareFixes" = {
            "enabled" = true;
          };
          "WhoReacted" = {
            "enabled" = true;
          };
          "XSOverlay" = {
            "enabled" = false;
          };
          "YoutubeAdblock" = {
            "enabled" = true;
          };
          "BadgeAPI" = {
            "enabled" = true;
          };
          "NoTrack" = {
            "enabled" = true;
            "disableAnalytics" = true;
          };
          "Settings" = {
            "enabled" = true;
            "settingsLocation" = "aboveNitro";
          };
          "DisableDeepLinks" = {
            "enabled" = true;
          };
          "SupportHelper" = {
            "enabled" = true;
          };
          "WebContextMenus" = {
            "enabled" = true;
          };
        };
        "notifications" = {
          "timeout" = 5000;
          "position" = "bottom-right";
          "useNative" = "not-focused";
          "logLimit" = 50;
        };
        "cloud" = {
          "authenticated" = false;
          "url" = "https://api.vencord.dev/";
          "settingsSync" = false;
          "settingsSyncVersion" = 1762342108885;
        };
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

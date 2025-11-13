{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    # Disable the systemd module to prevent conflict with
    # system-level UWSM setup
    systemd.enable = false;

    settings = {
      "$terminal" = "alacritty -e";
      "$textEditor" = "emacsclient -c";
      "$browser" = "firefox --new-window";
      "$get-monitor" = "hyprctl -j monitors | jq -r '. | map(select(.focused == true)) | .[] | .id'";
      "$launcher" = "ags request minibuffer $($get-monitor) :desktop";
      "$launch-browser" = "ags request minibuffer $($get-monitor) :web";
      "$launch-terminal" = "ags request minibuffer $($get-monitor) :shell";
      "$toggle-dock" = "ags request dock:toggle";

      "$mainMod" = "ALT";
      "$subMod" = "SUPER";

      env = [
        # Session info
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"

        # Default programs
        "TERM, $terminal"
        "VISUAL, $textEditor"
        "BROWSER, $browser"

        # XCursor
        "XCURSOR_THEME, Adwaita"
        "XCURSOR_SIZE, 24"

        # GTK
        "GDK_SCALE, 2"
        "GTK_THEME, MacTahoe-Dark"
        "GTK2_RC_FILES, ~/.themes/MacTahoe-Dark/gtk-2.0/gtkrc"

        # Qt

        ## Enable high-DPI
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "QT_ENABLE_HIGHDPI_SCALING, 1"

        ## Prevent font aliasing in high-DPI Qt6 programs
        "QT_SCALE_FACTOR_ROUNDING_POLICY, RoundPreferFloor"

        ## Force wayland as the first choice of backend
        "QT_QPA_PLATFORM, wayland:xcb"

        ## Don't draw window decorations
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_QPA_PLATFORMTHEME, gtk3"
      ];

      monitor = [
        ''DP-1, 3840x2160@144, auto, 1.5, bitdepth, 10, vrr, 1,
          # cm, hdr,
          # sdrbrightness, 1.0,
          # sdrsaturation, 1.2
        ''
        "DP-2, 2560x1440@144, auto-left, auto, bitdepth, 10"
        "HDMI-A-1, 1920x1080@60, auto-left, auto, bitdepth, 10"
        "DP-3, 1920x1200@60, auto-right, auto, bitdepth, 10"
      ];

      general = {
        "col.active_border" = "rgba(BD93F9ff)";
        "col.inactive_border" = "rgba(6272A4ff)";

        gaps_in = 5;
        gaps_out = 10;
      
        border_size = 2;
      
        # Don't resize windows by click-dragging on borders and gaps
        resize_on_border = false;
      
        # Don't wrap focus at edges
        no_focus_fallback = true;
      
        allow_tearing = false;
      
        layout = "master";
      };

      xwayland = {
        force_zero_scaling = true;
      };
      
      decoration = {
        rounding = 28;
        rounding_power = 2;
        
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        
        "shadow:enabled" = false;

        blur = {
            enabled = true;
            size = 1;
            passes = 5;
        };
      };

      animations = {
        enabled = "yes";
      
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
      
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 3, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3, easeOutQuint"
          "layersIn, 1, 3, easeOutQuint"
          "layersOut, 1, 3, easeOutQuint"
          "fadeLayersIn, 0, 3, linear"
          "fadeLayersOut, 1, 6, linear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

        
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        orientation = "left";
        new_status = "inherit";
        new_on_active = "after";
      };
      
      cursor = {
        hide_on_key_press = true;
      };
      
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        animate_manual_resizes = true;
      };
      
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
       
        repeat_rate = 30;
        repeat_delay = 200;
       
        follow_mouse = 1;
       
        sensitivity = 0;
        scroll_factor = 0.25;
       
        touchpad = {
          natural_scroll = false;
        };
      };
      
      device = {
          name = "ploopy-corporation-ploopy-adept-trackball-mouse";
          sensitivity = -0.75;
          accel_profile = "flat";
          scroll_method = "on_button_down";
          scroll_button = 277;
      };

      bind = [
        # Summon emacs
        "$mainMod, SPACE, exec, $textEditor"

        # Close active window
        "$mainMod, BACKSPACE, killactive,"
        
        # Exit hyprland
        "$mainMod $subMod, Q, exit,"
        
        # Reload hyprland
        "$mainMod $subMod, R, exec, hyprctl reload,"
        
        # Toggle active layout orientation
        "$subMod, SPACE, togglesplit"
        "$subMod, SPACE, exec, hyprctl dispatch layoutmsg orientationcycle"
        
        # Toggle between dwindle and master layouts
        ''
$subMod, BACKSPACE, exec, hyprctl keyword general:layout "$(hyprctl getoption general:layout | grep -q 'dwindle' && echo 'master' || echo 'dwindle')"
        ''
        
        # Move focus with mainMod + hjkl
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"
        
        # Roll through windows with io
        "$mainMod, i, exec, hyprctl dispatch layoutmsg rollnext"
        "$mainMod, o, exec, hyprctl dispatch layoutmsg rollprev"
        
        # Move windows with mainMod + ctrl + hjkl
        "$mainMod CTRL, h, movewindow, l"
        "$mainMod CTRL, j, movewindow, d"
        "$mainMod CTRL, k, movewindow, u"
        "$mainMod CTRL, l, movewindow, r"

        # Toggle fullscreen with mainMod + f
        "$mainMod, f, fullscreen"
        
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Toggle floating with mainMod + MMB
        "$mainMod, mouse:274, togglefloating"
        
        # Enter launch submap with Shift + Backspace
        "SHIFT, BACKSPACE, submap, launch"
      ];

      # Resize windows with subMod + hjkl
      binde = [
        "$subMod, h, resizeactive, -5% 0"
        "$subMod, j, resizeactive, 0 5%"
        "$subMod, k, resizeactive, 0 -5%"
        "$subMod, l, resizeactive, 5% 0"
      ];

      # Move/resize windows with mainMod + LMB/RMB and drag
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule = [
        # Ignore maximize requests from apps
        "suppressevent maximize, class:.*"
      
        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
      
      windowrulev2 = [
        # Float and center file picker dialogs
        "float, class:^(xdg-desktop-portal-gtk)$, title:^(Open Files)$"
        "center, class:^(xdg-desktop-portal-gtk)$, title:^(Open Files)$"
      ];
      
      layerrule = [
        # Slide layer shell edge widgets in and out
        "animation slide top 100%, ^(edge-top)$"
        "animation slide bottom 100%, ^(edge-bottom)$"
        "animation slide left 100%, ^(edge-left)$"
        "animation slide right 100%, ^(edge-right)$"
      
        # Blur edge widgets, even at zero opacity
        "blur, ^(edge-.*)$"
        "ignorezero, ^(edge-.*)$"
      ];

      exec-once = [
        # Apply wallpaper
        "swaybg -i ~/Pictures/wallpaper-mountain.png -m fill"

        # Autostart an emacs frame in server mode
        # and hide it in the special workspace
        "[workspace special silent] emacs --exec '(server-start)'"

        "dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME GTK_THEME GTK2_RC_FILES"

        # Start obelix layer shell
        "obelix"
      ];
    };

    submaps = {
      launch = {
        settings = {
          bind = [
            ", F, exec, $launch-terminal"
            ", F, submap, reset"
            "SHIFT, F, exec, $launch-terminal"
            "SHIFT, F, submap, reset"
            
            ", D, exec, $launch-browser"
            ", D, submap, reset"
            "SHIFT, D, exec, $launch-browser"
            "SHIFT, D, submap, reset"
            
            ", S, exec, $launcher"
            ", S, submap, reset"
            "SHIFT, S, exec, $launcher"
            "SHIFT, S, submap, reset"
            
            ", G, exec, $toggle-dock"
            ", G, submap, reset"
            "SHIFT, G, exec, $toggle-dock"
            "SHIFT, G, submap, reset"
           
            ", catchall, submap, reset"
          ];
        };
      };
    };

  };
}

# DONE

- [X] Investigate microcode patches
- [X] Update BIOS
  - Need to run BIOSRenamer.exe from windows before flashing
- [X] Restore windows boot capability
  - EFI setup lost during migration
  - Easier to just reinstall Tiny10 on /dev/sda
    - Set it up with its own EFI partition
    - Use guix grub chainloader functionality to expose a menu option
- [X] Strip out login manager
- [X] Fix ineffective cursor settings
  - Turned out to be missing `adwaita-icon-theme` following de-xorgification
- [X] Autostart hyprland
- [X] Setup gamemode
  - No need, already provided by flatpak

- [X] Setup mangohud

- [X] Fix PulseAudio in flatpak
  - Unable to connect to pulse, connection refused
  - Possibly down to pulse running as a system service, and pipewire in userland
  - Fixed by integrating pulseaudio home service

- [X] Launch file manager from Bottles
  - Caused by `xdg-desktop-portal-gtk` needing to run after hyprland comes up

- [X] Working Bottles
  
- [X] Update password-store password

- [X] Setup remaining home services
  - [X] SSH
  - [X] gnupg

- [X] Determine whether nonguix or flatpak Steam is preferable
  - Flatpak fine for running Steam-distributed games
    - Use Bottles for everything else

  - [X] Package oh-my-posh
    - [X] Write  initial package definition
    - [X] Package binary distribution instead of source
      - Manually packaging every go dependency is madness
      - Binary is less work, easier to maintain

- [X] Setup trivial transmission-daemon home service

- [X] Setup early KMS start
  - Need monitor EDID files

- [X] Launch browser from Discord
  - dbus-monitor reveals `OpenURI` being sent and reaching the portal, which then fails to find a handler for the HTTP / HTTPS mime type
    - Both are registered to icecat in ~/.config/mimeapps.list
    - Both function correctly when used with xdg-open
    - Conclusion: `xdg-desktop-portal` lacks the right environment?
      - Correct, needed to run `dbus-update-activation-environment` before starting portals

- [X] Fix IceCat desktop entry
  - Doesn't accept a URL parameter, so can't open links
  - Fixed by replacing IceCat with Zen

- [X] Replace Zen
  - Autofocusing address bar on new windows (issue #1742) makes it unusable with vim bindings, marked wontfix
  - New tab interface doesn't play well with 
  - Reinstate IceCat

- [X] Solve for system dark theme
  - Shouldn't need to override in every application
  - `dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"`
    - Worked to set Zen theme
      - Need to see if this persists across reboots
    - Didn't change any desktop-portal-gtk popups
  - Conclusion:
    - Persists across reboots
    - Works for desktop-portal-gtk with appropriate dbus env propagation

- [X] Setup floating window overrides for popups
  - File selector

- [X] Bindings for layout switching in hyprland
  - [X] Cycle
  - [X] Roll

- [X] Bindings for floating windows in hyprland
  - [X] Drag move
  - [X] Resize
  - [X] Toggle floating

- [X] Implement dconf service
  - Set values from an associative list
  - Use to make gnome color preference reproducible
  - Already supplied by NixOS

- [X] Trim unneeded packages from system config
  - NixOS is already minimal

- [X] Patch `Emacs (Client)` desktop file to open new windows
  - Is this still necessary following the switch to Nix?
    - No, just setting file associations

  - [X] Setup packaging workflow for zsh plugins
    - [X] zsh-autosuggestions
    - [X] zsh-syntax-highlighting
    - Installed plugins from guix repos

  - [X] Look into terminfo setup for kitty
    - No need, switched to Alacritty

  - [X] Reimplement corner and minibuffer widgets using AGS
    - More featureful than EWW
    - Allows arbitrary keypress events

  - [X] Fine-tune hyprland blur settings

- [X] Convert stateful configs to Home Manager
  - Probably a good fit for services
  - [X] dconf
  - [X] MIME types

- [X] Organize configs into module structure

- [X] Publish configs to github

- [X] Shell completion pass
  - https://github.com/zsh-users/zsh-completions/tree/master/src
    - Appears to have a guix package
  - Flatpak
  - Guix
    - httes://github.com/edmundmiller/guix-zsh-completions/tree/master
  - Provided by NixOS

- [N] Implement layer shell
  - SKIPPED: Can use noctalia if necessary
  - [ ] Split widgets into separate processes
    - Should be able to use AGS' multi-instance feature with conditional main
    - Ideally should probably be separate projects, as the windows don't share data
  - [X] Implement rounded monitor corners a-la webOS
  - [-] Implement minibuffer widget
    - [X] Basic command running
    - [X] Implement persistent black background underlay to hide fade artifacts
    - [X] Close on esc, ctrl+g, focus loss
    - [X] Dmenu-style filtering
    - [X] Desktop file launching
    - [X] Fix shell command behaviour
      - Arguably a redundant mode if a 'summon terminal' bind is available
    - [ ] Global shortcut visualization a-la emacs' which-key
      - Can parse `hyprctl -j binds`, populate descriptions
      - Filter by active submap
      - Likely better to focus the visualization window via prefix bind,
        and have it be authoritative over hotkey discharge
  - [-] Implement utility widgets
    - [-] Monitors
      - [X] CPU
      - [X] RAM
      - [X] GPU
      - [X] VRAM
      - [ ] Fans
        - Need to reinstigate custom fan control
      - [ ] Disks
      - [ ] Network
    - [ ] Audio control
    - [ ] GNU Pass
      - Custom pinentry
      - Dismissible username / password popup
    - [ ] Project
      - File browser with build shortcuts / status reporting / automation
      - Detect projects via git / cargo / etc
    - [ ] Window-swallowing launcher
    - [ ] Launcher categories
      - Applications / Games / Media / Tools / etc
        - Can use desktop file categories as a top-level URI segment
    - [ ] Power
      - Shutdown / Reboot

  - [ ] Theme bootloader

  - [-] Implement notification handling
    - [X] Basic proof-of-concept
    - [ ] GUI

  - [-] Implement tray handling
    - [X] Basic proof-of-concept
    - [ ] GUI

- [X] Integrate GTK file manager
  - [X] Select a file manager
    - Nautilus integrates the best
  - [X] Setup MIME associations
    - Is this still necessary following the move to NixOS?

- [N] Consider reinstating X11 emacs to fix PGTK performance issues
  - SKIPPED: Switched to neovim
  - Will need to adjust font sizes to account for 1x scaling
  - Smooth scrolling doesn't seem to work, event frequency maybe too high?

- [X] Consider trying neovide again
  - Emacs excellent for flexibility
  - ...But of limited benefit to an established workflow

- [N] Consider switching back to bash
  - SKIPPED: Dedicated shell service windows mean startup time is a non-issue
  - Faster startup times
  - May be able to recover some equivalent zsh functionality
  - Investigate fish
    - May end up cutting a better balance between performance and features

- [X] Look into niri again
  - [X] Regardless, put together a config
    - Should be easier once more functionality is moved into the layer shell
  - [X] Window rules for moving 'service windows' to dedicated workspaces
  - [X] Experiment with niri's built-in screen capture machinery
    - May be a tractable alternative to grimblast
  - [N] Try building blur branch for nix via flake
    - SKIPPED: Wait for official blur


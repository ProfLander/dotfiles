# TODO

## High Priority

- [X] Merge home-manager modules into nixos module
- [ ] Separate artemis / calliope home modules

- [-] Convert in-place configs to Home Manager
  - [-] .configs
    - [X] Alacritty
    - [X] Btop
    - [X] Git
    - [X] Hyprland
    - [X] Vesktop
    - [-] OBS
      - [X] Scenes
      - [ ] Capture target
        - Seems to be resetting on reboot
      - [ ] Recording settings
        - Should these be per-system?
    - [X] Firefox
      - [X] Transparency setting
      - [X] Theme
      - [X] Profiles
      - [X] Extensions
    - [ ] Retroarch
    - [ ] PCSX2
  - [ ] ~
    - [ ] .gitconfig
    - [ ] .profile
    - [ ] .Xauthority
    - [ ] .xinitrc
  - [-] Other
    - [ ] GTK theme
    - [ ] Pipewire configuration
      - Module for disabling everything
      - Module for enabling Arctis 7 + setting as default
    - [ ] ZSH Powerline

- [ ] Setup Matrix via NixOS modules
  - [ ] Homeserver
  - [ ] Discord Bridge
  - [ ] WhatsApp Bridge
  - [ ] Investigate other relevant bridges

- [ ] Test-drive noctalia

- [ ] Rebase niri, finish trackball sensitivity PR

- [ ] Configure neovim for terminal transparency

- [ ] Consider dropping neovide
  - Implement some sort of smart option-select
  - Run both neovim + neovide on main display, control via order
    - i.e. Navigate to bottom-most / top-most of the two, allow swapping position

## Medium Priority

- [ ] Reconfigure artemis BIOS
  - Be mindful of power management

- [ ] Setup cron backups
  - [ ] Copy important files to dedicated backup drive periodically

- [ ] Configure artemis OC / UV
  - [ ] CPU
  - [ ] GPU

- [-] System stability
  - RAM set to rated timing via DOCP
  - CPU at +5 voltage curve offset
  - CPU at -50mhz clock offset
  - Further investigation:
    - Kernel parameters (C-states, etc.)
      - https://www.klingt.net/articles/amd-ryzen-random-reboots-under-linux-when-in-idle.html
    - SysRq key for testing against lockups
      - https://wiki.archlinux.org/title/Keyboard_shortcuts#Kernel_(SysRq)
  - Stable for a full day after disabling DRAM Power Down Mode
  - Testing with stock clock and 0 curve offset...
  - System hang under 0 curve offset, increased to 4
    - Stable for a day or so thus far
    - Started freezing a day or two later
    - Need to bind REISUB and attempt to diagnose via logs etc
  - Increased curve offset to 5
    - Stable for a couple of days thus far
    - Still locks up, but much more rarely
  - Reduced CPU clock by 50mhz

- [ ] Setup EMMS equivalent
  - Automated media library
  - Persistent + transient playlists
- [ ] Setup elfeed equivalent
  - RSS for media sources
    - Potential use-case for notifications
  - Scripted playlist population

- [-] Organize filesystems
  - [X] Named mounts in `/mnt`
  - [ ] Denest `/mnt/media`
  - [ ] Clean out hanging `business` dir
  - [ ] Automount USB drive to `/mnt/usb`

## Low Priority

- [ ] Fix incorrect AM / PM display in oh-my-posh prompt

- [ ] Reinstate transmission home service

- [-] Investigate fancy themes
  - Ideally, everything should look like the emacs / terminal style
    - Transparency + blur etc
  - [X] Find a widget theme
    - MacTahoe-dark is good for general widgets
  - [X] Setup overrides to enable transparency
  - [X] Integrate with Flatpak
  - [ ] Integrate with Qt
    - OpenRGB currently displaying with a white theme
    - Should be able to configure via nix module
  - [ ] Find a cursor theme
  - [ ] Find an icon theme
  - [X] Refine GTK theme
    - [X] Improve titlebar contrast
    - [X] Theme dropdowns
    - [X] Improve separator appearance
      - Need to check against light theme
    - [X] Consider dialing back black-tinting for a more uniform glass look
    - [X] Replicate GTK3 overrides in GTK4
      - Fix Bottles add / install text separators
      - Transparent background for bottles 'add new' overlay
  - [ ] Refine Discord theme
    - [ ] Dark titlebar
    - [ ] Fira Code Nerd Font
    - [ ] Revert changes to discord / add server / compass icons
  - [X] Theme IceCat
  - [X] Reconsider Zen Browser
    - Transparent Zen plugin may allow for website opacity
    - May be able to hack the default URL bar focus out somehow
  - [X] Reconsider background color
    - Dracula BG too grey for glass effect, washes out image
  - [X] Theme fuzzel
    - Not blurring
    - Outline is too thin
    - Try to fix rignt-edge graphical issues
      - Could also consider other dmenu-standard wayland launchers
    - Abandoned in favor of layer shell

- [ ] Setup Stylix
  - [ ] Automatic wallpaper blur
  - [ ] Start by theming smaller applications
    - [ ] Alacritty
    - [ ] Neovim
    - [ ] Firefox
    - [ ] Vencord
  - Then move on to bigger ones
    - [ ] GTK theme
    - [ ] Qt

- [-] Collate list of emacs functionality to reproduce via layer shell
  - [X] pass
    - Quick access to credentials
  - [X] magit
    - Git operations with vim bindings
  - [X] dired
    - File browsing with vim bindings
  - [X] Find file
    - Partially accounted for via project pane
    - Means to start from current dir / home dir
    - History heuristic for considering oft-used files outside active directory
  - [X] Switch to buffer
    - Switch to window / monitor / workspace?
    - Window-specific switch action?
      - ex.
        - Switch buffers in text editor
        - Switch tabs in web browser
        - Switch directories in file manager
  - [X] Jump navigation
    - Jump to window / monitor / workspace

- [-] Setup convenient screen capture, recording, key shortcuts
  - [X] Install OBS
  - [X] Integrate with Bottles
  - [X] Replace  with guix distribution
  - [X] Fix `Screen Capture (Pipewire)` source
    - Renaming `portals-hyprland.conf` to `portals.conf` made it visible to OBS
      - Ergo, wasn't taking effect before, but no change re. discord links
    - However, capture doesn't work
      - Shows display selector
  - [-] Setup key shortcuts for compositor
    - [X] Start / Stop recording
      - Can use notifications to monitor progress
    - [X] Save last N seconds as video
    - [ ] Save last N seconds as gif

- [-] Finish porting zsh setup
  - [X] Fix tab completion
    - Stopped working after changes to .zshrc

  - [X] Theme oh-my-posh
  
  - [X] Setup return code reporting
  
  - [X] Fix initial prompt width
    - Switched to Alacritty, which handles it properly
      - No need for ligatures, since emacs handles them
  
  - [X] Setup command wrapping
    - By default, all stdout should be prefixed by a colored vertical bar
    - This won't work for TUI programs like `man` or `pulsemixer`
      - Need a blacklist
    - Gave up, as the complexity needed for robust function is too high

  - [-] Setup directory-specific segments
    - [X] Git
    - [ ] Plain
    - [ ] Rust
    - [ ] Scheme
    - [ ] CMake

  - [ ] Fix fuzzel command runner displaying incorrect error code
    - `ls` yields 1 instead of 0 on a successful run

- [-] Setup OpenRGB
  - [X] User install
  - [X] Setup udev rules
  - [X] Upgrade to system-level configuration
  - [ ] Configure
    - Ideally with reproducible dotfiles
  - [ ] Reintegrate rust capellix driver

- [ ] Investigate smart working directory for launchers
  - Fetch PID / other context from active window via hyprctl
  - Derive working directory to launch program in
  - Ideally should allow launching a program in the directory of the active kitty / emacs window

- [ ] Keyboard binding fixup
  - [ ] Bind `SysRq` key so REISUB can be used to recover cleanly
  - [ ] Swap alt / super on secondary keyboard

- [-] Package GTK theme
  - [X] Create git repo
  - [ ] Formalize as nix package


{ pkgs, ... }:

{
  # Grimblast for screenshots
  home.packages = [
      pkgs.grimblast
  ];

  # OBS Studio for video recording
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      # WLRoots integration
      wlrobs

      # Pipewire capture
      obs-pipewire-audio-capture

      # AMD hardware acceleration
      obs-vaapi

      # Vulkan capture
      obs-vkcapture

      # Input overlay
      input-overlay
    ];
  };
}

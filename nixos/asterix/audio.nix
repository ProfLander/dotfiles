{ inputs, ... }:

{
  # PipeWire
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    lowLatency.enable = true;
  };
}

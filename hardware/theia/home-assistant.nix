{ config, ... }:

{
  services.wyoming.piper.servers.tts = {
    enable = true;
    uri = "tcp://0.0.0.0:10200";
    voice = "en-gb-semaine-medium";
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      # TP-Link Tapo
      "tplink"
      "tplink_tapo"
      # Text to Speech
      "tts"
      "wyoming"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      # Text to Speech
      tts = [{
        platform = "piper";
      }];
    };
  };

  networking.firewall.allowedTCPPorts = [
    config.services.home-assistant.config.http.server_port
  ];
}

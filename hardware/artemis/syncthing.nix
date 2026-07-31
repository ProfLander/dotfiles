{
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "lander";
    group = "users";
    configDir = "/home/lander/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "anbernic-rg-cubexx" = {
          id = "IFQE7UT-KBL7MRI-LHGQBCN-MY2DJGO-4ZA6LTY-GQPCZPM-S2Q4RE2-7F6TGQN";
        };
      };

      folders = {
        "anbernic-rg-cubexx-archive" = {
          label = "Archives";
          group = "Anbernic RG CubeXX";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ARCHIVE";
          type = "sendreceive";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-saves" = {
          label = "Saves";
          group = "Anbernic RG CubeXX";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/saves";
          type = "receiveonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        # Metadata

        "anbernic-rg-cubexx-metadata/nintendo-nes" = {
          label = "NES";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo NES - Famicom";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-snes" = {
          label = "SNES";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo SNES - SFC";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/sega-master-system" = {
          label = "Sega Master System";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Sega Master System";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/sega-mega-drive" = {
          label = "Sega Mega Drive";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Sega Mega Drive - Genesis";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/sega-32x" = {
          label = "Sega 32X";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Sega 32X";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/sega-game-gear" = {
          label = "Sega Game Gear";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Sega Game Gear";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-virtual-boy" = {
          label = "Virtual Boy";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo Virtual Boy";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-64" = {
          label = "Nintendo 64";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo N64";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-game-boy" = {
          label = "Game Boy";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo Game Boy";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-game-boy-color" = {
          label = "Game Boy Color";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo Game Boy Color";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/nintendo-game-boy-advance" = {
          label = "Game Boy Advance";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/Nintendo Game Boy Advance";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-metadata/pc-engine" = {
          label = "PC Engine";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/NEC PC Engine";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        #"anbernic-rg-cubexx-metadata/pc-engine-supergrafx" = {
        #  label = "PC Engine SuperGrafx";
        #  group = "Anbernic RG CubeXX / Metadata";
        #  path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/NEC PC Engine SuperGrafx";
        #  type = "sendonly";
        #  devices = [
        #    "anbernic-rg-cubexx"
        #  ];
        #};

        #"anbernic-rg-cubexx-metadata/snk-neo-geo-pocket" = {
        #  label = "Neo Geo Pocket";
        #  group = "Anbernic RG CubeXX / Metadata";
        #  path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/SNK Neo Geo Pocket";
        #  type = "sendonly";
        #  devices = [
        #    "anbernic-rg-cubexx"
        #  ];
        #};

        "anbernic-rg-cubexx-metadata/snk-neo-geo-pocket-color" = {
          label = "Neo Geo Pocket Color";
          group = "Anbernic RG CubeXX / Metadata";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/MUOS/info/catalogue/SNK Neo Geo Pocket - Color";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        # ROMs

        "anbernic-rg-cubexx-roms/nintendo-nes" = {
          label = "NES";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo NES - Famicom";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-snes" = {
          label = "SNES";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo SNES - SFC";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/sega-master-system" = {
          label = "Sega Master System";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Sega Master System";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/sega-mega-drive" = {
          label = "Sega Mega Drive";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Sega Mega Drive - Genesis";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/sega-32x" = {
          label = "Sega 32X";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Sega 32X";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/sega-game-gear" = {
          label = "Sega Game Gear";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Sega Game Gear";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-virtual-boy" = {
          label = "Virtual Boy";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo Virtual Boy";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-64" = {
          label = "Nintendo 64";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo N64";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-game-boy" = {
          label = "Game Boy";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo Game Boy";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-game-boy-color" = {
          label = "Game Boy Color";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo Game Boy Color";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/nintendo-game-boy-advance" = {
          label = "Game Boy Advance";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/Nintendo Game Boy Advance";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/pc-engine" = {
          label = "PC Engine";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/NEC PC Engine";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        #"anbernic-rg-cubexx-roms/pc-engine-supergrafx" = {
        #  label = "PC Engine SuperGrafx";
        #  group = "Anbernic RG CubeXX / ROMs";
        #  path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/NEC PC Engine SuperGrafx";
        #  type = "sendonly";
        #  devices = [
        #    "anbernic-rg-cubexx"
        #  ];
        #};

        #"anbernic-rg-cubexx-roms/snk-neo-geo-pocket" = {
        #  label = "Neo Geo Pocket";
        #  group = "Anbernic RG CubeXX / ROMs";
        #  path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/SNK Neo Geo Pocket";
        #  type = "sendonly";
        #  devices = [
        #    "anbernic-rg-cubexx"
        #  ];
        #};

        "anbernic-rg-cubexx-roms/snk-neo-geo-pocket-color" = {
          label = "Neo Geo Pocket Color";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/SNK Neo Geo Pocket - Color";
          type = "sendonly";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };

        "anbernic-rg-cubexx-roms/pico-8" = {
          label = "Pico-8";
          group = "Anbernic RG CubeXX / ROMs";
          path = "/mnt/retro/matey/device/anbernic-rg-cubexx/sd-card/ROMS/pico8";
          type = "sendreceive";
          devices = [
            "anbernic-rg-cubexx"
          ];
        };
      };
    };
  };
}

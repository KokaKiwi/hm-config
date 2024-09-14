{ config, pkgs, lib, ... }:
with lib;
let
  inherit (config.lib) ctp;

  cfg = config.programs.discord;

  jsonFormat = pkgs.formats.json { };
in {
  options.programs.discord = {
    enable = mkEnableOption "Discord";

    flavour = mkOption {
      type = types.enum [
        "discord"
        "vesktop"
      ];
      default = "discord";
    };

    package = mkPackageOption pkgs "discord" {
      default = cfg.flavour;
    };

    vesktop = {
      settings = mkOption {
        type = jsonFormat.type;
        default = { };
        description = ''
          Vesktop settings written to
          {file}`$XDG_CONFIG_HOME/vesktop/settings.json`. See
          <https://github.com/Vencord/Vesktop/blob/main/src/shared/settings.d.ts>
          for available options
        '';
      };

      vencord = {
        useSystem = mkEnableOption "Vencord package from nixpkgs";

        catppuccin = ctp.mkCatppuccinOpt {
          name = "vencord";
        } // {
          accent = ctp.mkAccentOpt "vencord";
        };

        settings = mkOption {
          type = jsonFormat.type;
          default = { };
          description = ''
            Vencord settings written to
            {file}`$XDG_CONFIG_HOME/vesktop/settings/settings.json`. See
            <https://github.com/Vendicated/Vencord/blob/main/src/api/Settings.ts>
            for available options.
          '';
        };

        theme = mkOption {
          type = with types; nullOr (either lines path);
          default = null;
        };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.flavour == "discord") {
      home.packages = [
        cfg.package
      ];
    })
    (mkIf (cfg.flavour == "vesktop") {
      home.packages = [
        (cfg.package.override {
          withSystemVencord = cfg.vesktop.vencord.useSystem;
        })
      ];

      xdg.configFile = {
        "vesktop/settings.json" = mkIf (cfg.vesktop.settings != { }) {
          source = jsonFormat.generate "vesktop-settings.json" cfg.vesktop.settings;
        };
        "vesktop/settings/settings.json" = mkIf (cfg.vesktop.vencord.settings != { }) {
          source = jsonFormat.generate "vencord-settings.json" cfg.vesktop.vencord.settings;
        };
      };
    })
    (mkIf (cfg.flavour == "vesktop" && cfg.vesktop.vencord.theme != null) {
      programs.discord.vesktop.settings.enabledThemes = [ "theme.css" ];
      xdg.configFile."vesktop/themes/theme.css".source =
        if builtins.isPath cfg.vesktop.vencord.theme || isStorePath cfg.vesktop.vencord.theme
        then cfg.vesktop.vencord.theme
        else pkgs.writeText "vesktop-theme.css" cfg.vesktop.vencord.theme;
    })
    (mkIf (cfg.flavour == "vesktop" && cfg.vesktop.vencord.catppuccin.enable) {
      programs.discord.vesktop.vencord.theme = let
        catppuccin = config.programs.discord.vesktop.vencord.catppuccin;
      in ''
        @import"https://catppuccin.github.io/discord/dist/catppuccin-${catppuccin.flavor}-${catppuccin.accent}.theme.css";
      '';
    })
  ]);
}

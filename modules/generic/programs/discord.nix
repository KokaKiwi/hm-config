{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.discord;
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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [ cfg.package ];
    }
  ]);
}

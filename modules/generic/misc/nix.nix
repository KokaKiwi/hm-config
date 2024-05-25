{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.nix;

  filterMap = cond: transform: set:
    map transform (filter cond set);

  nixBuilder = {
    uri,
    systems,
    identityFile,
    maxJobs,
    speedFactor,
    supportedSystemFeatures,
    requiredSystemFeatures,
    hostKey,
  }:
  let
    nullOr = value: if value == null then "-" else (toString value);
    emptyOr = value: if value == [ ] then "-" else (concatStringsSep "," value);
  in concatStringsSep " " [
    uri
    (emptyOr systems)
    (nullOr identityFile)
    (nullOr maxJobs)
    (nullOr speedFactor)
    (emptyOr supportedSystemFeatures)
    (emptyOr requiredSystemFeatures)
    (nullOr hostKey)
  ];

  builderType = types.submodule {
    options = {
      enable = mkEnableOption "Enable builder" // { default = true; };

      uri = mkOption {
        type = types.str;
      };

      systems = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
      identityFile = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };
      maxJobs = mkOption {
        type = with types; nullOr ints.positive;
        default = null;
      };
      speedFactor = mkOption {
        type = with types; nullOr ints.positive;
        default = null;
      };
      supportedSystemFeatures = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
      requiredSystemFeatures = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
      hostKey = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };
    };
  };

  channelsPackage = let
    mkEntry = name: drv: {
      inherit name;
      path = toString drv;
    };
  in pkgs.linkFarm "nix-channels" (mapAttrsToList mkEntry cfg.channels);
  channelsPath = "${cfg.defExprDirectory}/50-home-manager";
in {
  options.nix = {
    builders = mkOption {
      type = with types; attrsOf builderType;
      default = { };
    };

    defExprDirectory = mkOption {
      type = types.path;
      readOnly = true;
    };

    nixPath = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    overrideNixPath = mkOption {
      type = types.bool;
      default = false;
    };

    channels = mkOption {
      type = with types; attrsOf package;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    nix.settings.builders =
      let
        builders' = filterMap
          ({ enable ? true, ... }: enable)
          (builder: nixBuilder (builtins.removeAttrs builder [ "enable" ]))
          (builtins.attrValues cfg.builders);
        machines = pkgs.writeText "machines" (concatLines builders');
      in mkIf (builders' != []) "@${machines}";

    nix.defExprDirectory =
      if cfg.enable && (cfg.settings.use-xdg-base-directories or false)
      then "${config.xdg.stateHome}/nix/defexpr"
      else "${config.home.homeDirectory}/.nix-defexpr";

    home.sessionVariables = mkIf (cfg.nixPath != [ ]) {
      NIX_PATH = let
        nixPath = concatStringsSep ":" cfg.nixPath;
      in if cfg.overrideNixPath then nixPath else "${nixPath}\${NIX_PATH:+:$NIX_PATH}";
    };

    nix.nixPath = mkIf (cfg.channels != { }) [ channelsPath ];
    home.file.${channelsPath} = mkIf (cfg.channels != { }) {
      source = channelsPackage;
    };
  };
}

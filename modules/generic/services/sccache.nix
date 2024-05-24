{ config, lib, ... }:
with lib;
let
  cfg = config.services.sccache;

  programCfg = config.programs.sccache;
in {
  options.services.sccache = {
    enable = mkEnableOption "sccache server" // {
      default = programCfg.enable;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> programCfg.enable;
        message = "programs.sccache must be enabled for services.sccache to be enabled";
      }
    ];

    systemd.user.services."sccache-server" = {
      Unit = {
        Description = "Sccache server";
      };
      Service = {
        Restart = "always";
        ExecStart = "${programCfg.package}/bin/sccache";
        Environment = toString [
          "SCCACHE_START_SERVER=1"
          "SCCACHE_NO_DAEMON=1"
        ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

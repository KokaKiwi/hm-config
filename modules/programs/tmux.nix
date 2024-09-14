{ config, lib, ... }:
with lib;
let
  cfg = config.programs.tmux;

  tmuxConf = ''
    ${optionalString (cfg.updateEnvironment != [ ]) ''
      set-option -g update-environment "${concatStringsSep " " cfg.updateEnvironment}"
    ''}
  '';
in {
  options = {
    programs.tmux = {
      enableSystemd = mkEnableOption "Enable user systemd service";

      updateEnvironment = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."tmux/tmux.conf".text = mkOrder 700 tmuxConf;

    systemd.user.services."tmux" = mkIf cfg.enableSystemd {
      Unit = {
        Description = "Start tmux in detached session";
        After = [ "systemd-tmpfiles-setup.service" ];
      };

      Service = {
        Type = "forking";
        ExecStart = "${getExe cfg.package} -2 new-session -s ${config.home.username} -dP";
        ExecStop = "${getExe cfg.package} kill-session -t ${config.home.username}";
      };

      Install = {
        WantedBy = [ "environment.target" ];
      };
    };

    lib.tmux = {
      formatOptions = {
        prefix ? "",
      }: attrs: concatStringsSep "\n" (flip mapAttrsToList attrs (name: value:
        ''set -g @${prefix}${name} "${value}"''
      ));
    };
  };
}

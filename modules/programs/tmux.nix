{ config, lib, ... }:
let
  inherit (config.lib) tmux;

  cfg = config.programs.tmux;

  tmuxConf = ''
    ${lib.optionalString (cfg.updateEnvironment != [ ]) ''
      set-option -g update-environment "${lib.concatStringsSep " " cfg.updateEnvironment}"
    ''}
  '';
in {
  options = {
    programs.tmux = with lib; {
      enableSystemd = mkEnableOption "Enable user systemd service";

      updateEnvironment = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      extraOptions = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };

  config = with lib; mkIf cfg.enable {
    programs.tmux = {
      extraConfig = mkIf (cfg.extraOptions != { }) (tmux.formatOptions {
        prefix = "";
      } cfg.extraOptions);
    };

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
        prefix ? "@",
      }: attrs: concatStringsSep "\n" (flip mapAttrsToList attrs (name: value:
        ''set -g ${prefix}${name} "${value}"''
      ));
    };
  };
}

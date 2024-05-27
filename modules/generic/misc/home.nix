{ pkgs, lib, ... }:
{
  options.home = with lib; {
    shell = mkOption {
      type = types.submodule ({ config, ... }: {
        options = {
          package = mkPackageOption pkgs "bash" { };
          exeName = mkOption {
            type = with types; nullOr str;
            default = null;
          };

          fullPath = mkOption {
            type = types.str;
            readOnly = true;
          };
        };

        config = {
          fullPath = if config.exeName != null
            then "${config.package}/bin/${config.exeName}"
            else lib.getExe config.package;
        };
      });
      default = { };
    };
  };
}

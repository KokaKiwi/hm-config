{ config, pkgs, ... }:
{
  programs.glances = {
    package = config.lib.python.extendPackageEnv pkgs.glances (ps: with ps; [
      batinfo
      docker
      netifaces
    ]);

    settings = {
      global = {
        check_update = false;
      };
    };
  };
}

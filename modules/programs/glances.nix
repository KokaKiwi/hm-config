{ config, pkgs, ... }:
{
  programs.glances = {
    enable = true;
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

{ config, pkgs, ... }:
{
  programs.ptpython = {
    package = config.lib.python.extendPackageEnv pkgs.ptpython (ps: with ps; [
      ipython
    ]);
  };
}

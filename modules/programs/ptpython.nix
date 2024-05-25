{ config, pkgs, ... }:
{
  programs.ptpython = {
    package = config.lib.python.extendPackageEnv pkgs.python312Packages.ptpython (ps: with ps; [
      ipython
    ]);
  };
}

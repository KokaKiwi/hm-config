{ config, pkgs, lib, ... }:
{
  programs.nvchecker = {
    package = let
      python3Packages = pkgs.python312Packages;
      nvchecker = python3Packages.nvchecker;
    in config.lib.python.extendPackageEnv nvchecker (_: lib.flatten (lib.attrValues nvchecker.optional-dependencies));
  };
}

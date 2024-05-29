{ config, pkgs, lib, ... }:
{
  programs.nvchecker = {
    package = let
      python3Packages = pkgs.python312Packages;
      nvchecker = python3Packages.nvchecker.overridePythonAttrs (super: rec {
        version = "2.15";

        src = pkgs.fetchFromGitHub {
          owner = "lilydjwg";
          repo = "nvchecker";
          rev = "v${version}";
          hash = "sha256-MEZvBVsO3JpmyeeB3DECqt2Ynbdf8X8BfNTTUbK3N58=";
        };
      });
    in config.lib.python.extendPackageEnv nvchecker (_: lib.flatten (lib.attrValues nvchecker.optional-dependencies));
  };
}

{ config, pkgs, lib, ... }:
{
  programs.nvchecker = {
    enable = true;
    package = let
      python3Packages = pkgs.python312Packages;
      nvchecker = python3Packages.nvchecker.overridePythonAttrs (super: rec {
        version = "2.15.1";

        src = pkgs.fetchFromGitHub {
          owner = "lilydjwg";
          repo = "nvchecker";
          rev = "v${version}";
          hash = "sha256-dK3rZCoSukCzPOFVectQiF6qplUuDBh9qyN8JL0+j20=";
        };
      });
    in config.lib.python.extendPackageEnv nvchecker (_: lib.flatten (lib.attrValues nvchecker.optional-dependencies));
  };
}

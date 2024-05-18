{ pkgs, lib, ... }:
with lib;
{
  programs.nvchecker = {
    package = let
      python = pkgs.python312;
      nvchecker = python.pkgs.nvchecker;
    in nvchecker.overridePythonAttrs {
      dependencies = flatten (attrValues nvchecker.optional-dependencies);
    };
  };
}

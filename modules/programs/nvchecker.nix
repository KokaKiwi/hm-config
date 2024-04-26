{ pkgs, lib, ... }:
{
  programs.nvchecker = {
    package = let
      python = pkgs.python312;
      pythonEnv = python.withPackages (ps: with ps; [
        nvchecker
      ] ++ lib.flatten (builtins.attrValues nvchecker.optional-dependencies));
    in pkgs.runCommand "nvchecker" { } ''
      mkdir -p $out/bin
      for exe in ${pythonEnv}/bin/{nvchecker{,-notify},nvcmp,nvtake}; do
        ln -s $exe $out/bin/$(basename "$exe")
      done
    '';
  };
}

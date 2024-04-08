{ pkgs, ... }:
{
  programs.nvchecker = {
    package = pkgs.python312Packages.nvchecker;
  };
}

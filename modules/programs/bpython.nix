{ pkgs, ... }:
{
  programs.bpython = {
    package = pkgs.python312Packages.bpython;
  };
}

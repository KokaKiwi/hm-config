{ pkgs, ... }:
{
  programs.sccache = {
    enable = true;
    package = pkgs.nur.repos.kokakiwi.sccache;
  };
}

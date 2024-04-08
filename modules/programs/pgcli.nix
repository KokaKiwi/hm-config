{ config, pkgs, ... }:
{
  programs.pgcli = {
    package = pkgs.python312Packages.pgcli;

    settings = config.lib.files.localConfigPath "pgcli/config";
  };
}

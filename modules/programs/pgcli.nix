{ config, ... }:
{
  programs.pgcli = {
    settings = config.lib.files.localConfigPath "pgcli/config";
  };
}

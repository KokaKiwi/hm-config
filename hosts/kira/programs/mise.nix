{ config, ... }:
{
  programs.mise = {
    enable = true;

    globalConfig = {
      tools = {
        cmake = "system";
        crystal = "latest";
        golang = "system";
        gradle = "latest";
        java = "system";
        kotlin = "system";
        node = [ "system" "lts" "16" "18" "20" "21" ];
        pnpm = "system";
        python = [ "system" "3.12" ];
      };
    };

    settings = {
      trusted_config_paths = [
        "${config.home.homeDirectory}/projects"
      ];

      experimental = true;
      legacy_version_file = false;
      pipx_uvx = true;
    };
  };
}

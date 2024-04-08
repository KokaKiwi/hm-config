{ ... }:
{
  programs.yazi = {
    enableFishIntegration = true;

    catppuccin.enable = true;

    settings = {
      manager = {
        sort_dir_first = true;
      };
    };
  };
}

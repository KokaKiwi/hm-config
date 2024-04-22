{ ... }:
{
  programs.yazi = {
    enableFishIntegration = true;

    settings = {
      manager = {
        sort_dir_first = true;
      };
    };
  };
}

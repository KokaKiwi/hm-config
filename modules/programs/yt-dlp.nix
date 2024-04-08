{ pkgs, ... }:
{
  programs.yt-dlp = {
    package = pkgs.python312Packages.yt-dlp;
  };
}

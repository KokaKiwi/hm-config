{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    package = pkgs.kiwiPackages.gnupg;
    settings = {
      keyserver = "keyserver.ubuntu.com";
    };
  };
}

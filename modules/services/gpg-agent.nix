{ pkgs, ... }:
{
  services.gpg-agent = {
    defaultCacheTtl = 2592000;
    maxCacheTtl = 2592000;

    pinentryPackage = pkgs.pinentry-curses;
  };
}

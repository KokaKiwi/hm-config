{ pkgs, ... }:
{
  programs.kde = {
    akonadi = {
      postgresql = pkgs.postgresql_16;
    };
  };
}

{ pkgs, ... }:
{
  config = {
    programs.silicon = {
      enable = true;
      package = pkgs.silicon.override {
        rustPlatform = pkgs.fenixStableRustPlatform;
        python3 = pkgs.python312;
      };
    };
  };
}

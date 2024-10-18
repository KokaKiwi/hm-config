{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.31";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-zHitG4Ktt+iCKk9GrC3C4MRSWhUxh89kW9bUeHzqNJs=";
    };
  });
}

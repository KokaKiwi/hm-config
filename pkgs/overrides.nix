{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.27";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-Ir0EQH+bnHPwOTakrO/ZQ6pyeOWvhu5bK5j+YLN8Myc=";
    };
  });
}

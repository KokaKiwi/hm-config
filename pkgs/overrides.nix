{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.34";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-S8AA/1CWxTSHZ60E2ZNQXyEAOalYgCc6dte9CvD8Lx8=";
    };
  });

  gnupg24 = super.gnupg24.overrideAttrs (self: prev: {
    version = "2.4.6";

    src = pkgs.fetchurl {
      url = "mirror://gnupg/gnupg/${self.pname}-${self.version}.tar.bz2";
      hash = "sha256-laz6/acASSSm9ckBZ38VrBvaJ1RRHZc7tFI+jdhA4Xo=";
    };
  });
}

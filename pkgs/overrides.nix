{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.28";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-ZEhYhecMV0EOvC26bEYqguW8RkPVeT+q3a1ZZyXHeQk=";
    };
  });
}

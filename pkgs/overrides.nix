{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.26";

    buildInputs = [ ];

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-qHBNhvZRTjBEmDOsMJRIz4TgiLbtuWjgVHfP+aBaqio=";
    };
  });
}

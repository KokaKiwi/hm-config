{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.33";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-oAIFp9WnScRx+VJXwknnUMBQT7S9nugyD+45qJu6qFg=";
    };
  });
}

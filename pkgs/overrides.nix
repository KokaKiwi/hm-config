{ pkgs, super }:
{
  # Udated packages
  bun = super.bun.overrideAttrs (self: prev: {
    version = "1.1.30";

    src = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
      hash = "sha256-UGDyM+7L7YGXaGs3sOstqP9SKC9XvR3Y45T1Ov3shA4=";
    };
  });
}

{ sources, ... }:
{
  nixpkgs.overlays = [
    (self: super:
      import ../../pkgs {
        pkgs = self;
        inherit super sources;
      }
    )
  ];

  _module.args = {
    pkgsPath = sources.nixpkgs;
  };
}

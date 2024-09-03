{ config, pkgs, lib, ... }:
let
  cfg = config.services.syncthing;
in {
  services.syncthing = {
    enable = true;

    tray = {
      enable = true;
      package = pkgs.qsyncthingtray;
      command = "qsyncthingtray";
    };
  };

  systemd.user.services.${cfg.tray.package.pname} = {
    Unit.Requires = lib.mkForce [ ];
  };
}

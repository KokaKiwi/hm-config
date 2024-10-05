{ ... }:
{
  imports = [
    ./services/aria2.nix
    ./services/gpg-agent.nix
    ./services/kubo.nix
    ./services/nextcloud.nix
    ./services/nix-web.nix
    ./services/podman.nix
    ./services/pueue.nix
    ./services/syncthing.nix
  ];

  services = {
    module-server.enable = true;
    sccache.enable = true;
  };
}

{ ... }:
{
  imports = [
    ./services/aria2.nix
    ./services/gpg-agent.nix
    ./services/kubo.nix
    ./services/nix-web.nix
    ./services/pueue.nix
  ];

  services = {
    module-server.enable = true;
    sccache.enable = true;
  };
}

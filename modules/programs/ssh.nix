{ config, lib, ... }:
with lib;
let
  hosts = config.programs.ssh.matchBlocks;

  ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes128-gcm@openssh.com"
    "aes256-gcm@openssh.com"
    "aes256-ctr"
    "aes192-ctr"
    "aes128-ctr"
  ];

  machines = {
    kiwi-games = {
      hostname = "192.168.1.225";
    };
  };
in {
  programs.ssh = {
    matchBlocks = {
      "gitlab.kokakiwi.net" = {
        identityFile = "~/.ssh/id_ed25519";
      };

      aur = {
        host = "aur aur.archlinux.org";
        hostname = "aur.archlinux.org";
        user = "aur";
        identityFile = "~/.ssh/id_aur";
      };

      "alma*" = {
        user = "alarm";
        identityFile = "~/.ssh/id_ed25519";
      };

      alma = hm.dag.entryAfter [ "alma*" ] {
        hostname = "alma.lan";
      };

      alyx = {
        hostname = "alyx.kokakiwi.net";
        user = "kokakiwi";
        identityFile = "~/.ssh/id_ed25519";
      };
      mel = {
        hostname = "mel.kokakiwi.net";
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
      };

      archrepo = {
        inherit (hosts.alyx.data) hostname;
        user = "archrepo";
        identityFile = "~/.ssh/id_ed25519";
      };

      galileo = {
        hostname = "192.168.1.1";
        user = "pi";
        identityFile = "~/.ssh/id_router";
      };

      nix-games = {
        inherit (machines.kiwi-games) hostname;
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
        port = 2222;
      };

      arch-games = {
        inherit (machines.kiwi-games) hostname;
        user = "arch";
        identityFile = "~/.ssh/id_ed25519";
        port = 2223;
      };

      kiwivault = {
        hostname = "192.168.1.80";
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
      };
      "kiwivault.ygg" = {
        hostname = "203:9e60:bd6d:d73b:55e5:ed7a:a11c:ebf1";
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
      };
    };

    authorizedKeys = [ ];

    extraConfig = ''
      VerifyHostKeyDNS yes
      Ciphers ${concatStringsSep "," ciphers}
    '';
  };
}

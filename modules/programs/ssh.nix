{ lib, ... }:
with lib;
let
  ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes128-gcm@openssh.com"
    "aes256-gcm@openssh.com"
    "aes256-ctr"
    "aes192-ctr"
    "aes128-ctr"
  ];

  machines = {
    alyx = {
      address = "alyx.kokakiwi.net";
    };

    galileo = {
      address = "192.168.1.1";
    };
    kiwi-games = {
      address = "192.168.1.225";
    };
    glados = {
      address = "192.168.1.65";
    };

    vps-25707 = {
      address = "37.205.12.231";
    };
  };
in {
  programs.ssh = {
    matchBlocks = {
      "gitlab.kokakiwi.net" = {
        identityFile = "~/.ssh/id_ed25519";
      };

      aur = {
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
        hostname = machines.alyx.address;
        user = "kokakiwi";
        identityFile = "~/.ssh/id_ed25519";
      };

      archrepo = {
        hostname = machines.alyx.address;
        user = "archrepo";
        identityFile = "~/.ssh/id_ed25519";
      };

      glados = {
        hostname = machines.glados.address;
        user = "kokakiwi";
        identityFile = "~/.ssh/id_ed25519";
      };

      galileo = {
        hostname = machines.galileo.address;
        user = "pi";
        identityFile = "~/.ssh/id_router";
      };

      nix-games = {
        hostname = machines.kiwi-games.address;
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
        port = 2222;
      };

      arch-games = {
        hostname = machines.kiwi-games.address;
        user = "arch";
        identityFile = "~/.ssh/id_ed25519";
        port = 2223;
      };

      vps-25707 = {
        hostname = machines.vps-25707.address;
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

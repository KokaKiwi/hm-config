{ config, lib, ... }:
with lib;
let
  files = config.lib.files;

  machines = {
    default = {
      user = "kokakiwi";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      addressFamily = "inet6";
    };
    staging = {
      names = [
        "caribou" "origan" "piranha" "df-pw5"
      ];
      hostname = "%h.machine.staging.deuxfleurs.org";
    };
    prod = {
      names = [
        "concombre" "courgette" "celeri" "dahlia" "diplotaxis"
        "doradille" "df-ykl" "df-ymf" "df-ymk" "abricot"
        "ananas" "onion" "oseille" "io"
      ];
      hostname = "%h.machine.deuxfleurs.fr";
    };
  };

  machines-local = {
    onion = "192.168.1.34";
    oseille = "192.168.1.35";
    io = "192.168.1.36";
  };
in {
  data.deuxfleurs = {
    members = [
      "lx" "adrien" "quentin" "baptiste" "maximilien"
      "armael" "boris" "aeddis" "vincent" "trinity-1686a"
      "darkgallium" "marion"
    ];
  };

  programs.gpg.publicKeys = map (name: {
    source = files.localFilePath "gpg-keyring/deuxfleurs/${name}.gpg";
    trust = "full";
  }) config.data.deuxfleurs.members;

  programs.ssh.matchBlocks = {
    deuxfleurs-git = {
      host = "git.deuxfleurs.fr";
      user = "git";
      identityFile = "~/.ssh/id_deuxfleurs";
    };
  }
  // (mapAttrs' (name: { names, ... }@args: {
    name = "deuxfleurs-${name}";
    value = machines.default // (flip builtins.removeAttrs [ "names" ] args) // {
      host = toString names;
    };
  }) (flip builtins.removeAttrs [ "default" ] machines))
  // (mapAttrs' (name: address: {
    name = "deuxfleurs-${name}-local";
    value = {
      host = "${name}-local";
      user = "kokakiwi";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      hostname = address;
    };
  }) machines-local);

  # programs.ssh.matchBlocks = mkMerge [
  #   (mapAttrs' (name: { names, ... }@args: {
  #     name = "deuxfleurs-${name}";
  #     value = machines.default // (flip builtins.removeAttrs [ "names" ] args) // {
  #       host = concatStringsSep " " names;
  #     };
  #   }) (flip builtins.removeAttrs [ "default" ] machines))
  #   (mapAttrs' (name: address: {
  #     name = "deuxfleurs-${name}-local";
  #     value = {
  #       user = "kokakiwi";
  #       identitiesOnly = true;
  #       identityFile = "~/.ssh/id_ed25519";
  #       hostname = address;
  #     };
  #   }) machines-local)
  #   {
  #     deuxfleurs-git = {
  #       host = "git.deuxfleurs.fr";
  #       user = "git";
  #       identityFile = "~/.ssh/id_deuxfleurs";
  #     };
  #   }
  # ];
}

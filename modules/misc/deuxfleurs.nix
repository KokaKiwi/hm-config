{ config, lib, ... }:
with lib;
let
  publicKeys = let
    names = [
      "lx" "adrien" "quentin" "baptiste" "maximilien"
      "armael" "boris" "aeddis" "vincent" "trinity-1686a"
      "darkgallium" "marion"
    ];
  in map (name: {
    source = config.lib.files.localFilePath "gpg-keyring/deuxfleurs/${name}.gpg";
    trust = "full";
  }) names;

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
        "ananas"
      ];
      hostname = "%h.machine.deuxfleurs.fr";
    };
  };
in {
  programs.gpg.publicKeys = publicKeys;

  programs.ssh.matchBlocks = mapAttrs' (name: { names, ... }@args: {
    name = "deuxfleurs-${name}";
    value = machines.default // (flip builtins.removeAttrs [ "names" ] args) // {
      host = concatStringsSep " " names;
    };
  }) (flip builtins.removeAttrs [ "default" ] machines);
}

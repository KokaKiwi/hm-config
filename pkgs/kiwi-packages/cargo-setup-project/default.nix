{ lib

, writeShellScriptBin
, substituteAll

, cargo ? "cargo"
}:
let
  files = {
    ".mise.toml" = ./mise.toml;
    "Justfile" = substituteAll {
      src = ./Justfile.base;
      inherit cargo;
    };
  };
in writeShellScriptBin "cargo-setup-project" ''
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: source:
    "cp -Tr --no-preserve=mode ${source} ${name}"
  ) files)}
''

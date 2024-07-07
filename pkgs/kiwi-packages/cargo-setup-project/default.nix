{ lib

, writeShellScriptBin
}:
let
  files = {
    ".mise.toml" = ./mise.toml;
    "Justfile" = ./Justfile.base;
  };
in writeShellScriptBin "cargo-setup-project" ''
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: source:
    "cp -Tr --no-preserve=mode ${source} ${name}"
  ) files)}
''

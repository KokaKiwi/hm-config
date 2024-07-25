{ lib

, writeShellScriptBin
, substituteAll

, cargo ? "cargo"
}:
let
  files = {
    ".mise.toml" = {
      src = ./mise.toml;
      overwrite = false;
    };
    "Justfile" = {
      src = substituteAll {
        src = ./Justfile.base;
        inherit cargo;
      };
    };
  };
in writeShellScriptBin "cargo-setup-project" ''
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: {
    src,
    overwrite ? true,
  }: lib.concatStringsSep " " (
    (lib.optional (!overwrite) "[[ -f \"${name}\" ]] &&")
    ++ [
      "cp -Tr --no-preserve=mode ${src} ${name}"
    ]
  )) files)}
''

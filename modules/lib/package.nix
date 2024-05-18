{ pkgs, lib, ... }:
{
  lib.package = {
    wrapPackage = drv: {
      suffix ? null,
      nativeBuildInputs ? [ ]
    }: buildCommand: drv.overrideAttrs (super: {
      name = if suffix != null
        then "${drv.name}${suffix}"
        else drv.name;

      nativeBuildInputs = with pkgs; [ makeWrapper ] ++ nativeBuildInputs;

      separateDebugInfo = false;

      buildCommand = ''
        set -eo pipefail

        ${lib.concatMapStringsSep "\n" (outputName: ''
          echo "Copying output ${outputName}"

          cp -rs --no-preserve=mode ${drv.${outputName}} ''$${outputName}
        '') (super.outputs or [ "out" ])}

        ${buildCommand}
      '';
    });
  };
}

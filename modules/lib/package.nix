{ pkgs, lib, ... }:
{
  lib.package = {
    wrapPackage = drv: {
      suffix ? "",
      nativeBuildInputs ? [ ],
      makeWrapper ? pkgs.makeShellWrapper
    }: buildCommand: drv.overrideAttrs (super: {
      name = "${drv.name}${suffix}";

      nativeBuildInputs = [
        makeWrapper
      ] ++ nativeBuildInputs;

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

{ lib, ... }:
{
  lib.python = {
    extendPackageEnv = drv: f: let
      python = drv.pythonModule;

      env = python.withPackages (ps: (f ps) ++ [ drv ]);
    in drv.overrideAttrs (super: let
      extraOutputs = lib.remove "out" (super.outputs or [ "out" ]);
    in {
      name = "${drv.name}-with-env";

      separateDebugInfo = false;

      outputs = [ "out" ] ++ extraOutputs;

      buildCommand = ''
        set -eo pipefail

        ${lib.concatMapStrings (outputName: ''
          echo "Copying output ${outputName}"

          cp -rs --no-preserve=mode ${drv.${outputName}} ''$${outputName}
        '') extraOutputs}

        mkdir -p $out/bin
        for executable in ${drv.out}/bin/*; do
          ln -s ${env.out}/bin/$(basename $executable) $out/bin/$(basename $executable)
        done
      '';
    });
  };
}

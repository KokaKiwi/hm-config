{ doWarn ? false
}:
let
  env = import ./default.nix { };

  inherit (env) config pkgs;
  inherit (pkgs) lib;

  updateChecker = import ./scripts/update-checker.nix (env // {
    inherit doWarn;
  });
in pkgs.mkShell {
   packages = with pkgs; [
     git
     jq
     config.nix.package
     nix-output-monitor
     nixos-option
  ];

  shellHook = ''
    init() {
      git clone gitlab@gitlab.kokakiwi.net:kokakiwi/home-manager-secrets.git secrets
      switch
    }

    switch() {
      local workDir=$(mktemp --tmpdir -d)
      trap "rm -rf $workDir" EXIT

      local generationDir="$workDir/generation"

      nom-build --out-link "$generationDir" && \
        "$generationDir/activate"
    }

    listPackages() {
      nix-instantiate --eval --strict --json --expr ${lib.escapeShellArg ''
        let
          env = (import ./default.nix {}).env;
          inherit (env) pkgs homePackages;
          inherit (pkgs) lib;
        in lib.mapAttrs (name: drv: drv.version) homePackages
      ''} | jq -r 'to_entries | map("\(.key) \(.value)") | .[]'
    }

    copyPackage() {
      local src="$1"
      local dst="$2"

      mkdir -p pkgs/$(dirname $dst)
      cp -Tr ${pkgs.path}/pkgs/$src pkgs/$dst
      chmod -R +w pkgs
    }

    checkUpdates() {
      ${updateChecker}
    }
  '';
}

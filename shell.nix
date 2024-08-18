{ doWarn ? false
}:
let
  env = import ./default.nix { };

  inherit (env) config pkgs;
  inherit (pkgs) lib;

  updateChecker = import ./scripts/update-checker.nix (env // {
    inherit doWarn;
  });
  duplicateChecker = import ./scripts/duplicate-checker.nix env;
in pkgs.mkShell {
   packages = with pkgs; [
     git
     jq
     config.nix.package
     nix-output-monitor
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

    checkUpdates() {
      ${updateChecker}
    }

    checkDuplicate() {
      ${duplicateChecker}
    }
  '';
}

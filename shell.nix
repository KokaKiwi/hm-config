{ doWarn ? false
}:
let
  module = import ./default.nix { };

  inherit (module) pkgs hosts;
  inherit (pkgs) lib;

  updateChecker = import ./scripts/update-checker.nix (hosts.kira // {
    inherit doWarn;
  });
in pkgs.mkShell {
   packages = with pkgs; [
     git
     jq
     hosts.kira.config.nix.package
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
  '';
}

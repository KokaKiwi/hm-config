let
  env = import ./default.nix { };

  inherit (env) config pkgs;
in pkgs.mkShell {
  buildInputs = with pkgs; [
    gitMinimal
    jq
    config.nix.package
    nix-output-monitor
    nixos-option
    nix-update
  ];

  shellHook = ''
    init() {
      git clone gitlab@gitlab.kokakiwi.net:kokakiwi/home-manager-secrets.git secrets
      switch
    }

    build() {
      nom-build
    }

    switch() {
      local workDir=$(mktemp --tmpdir -d)
      trap "rm -rf $workDir" EXIT

      local generationDir="$workDir/generation"

      nom-build --out-link "$generationDir" && \
        "$generationDir/activate"
    }

    buildPackage() {
      local name="$1"

      NIXPKGS_ALLOW_BROKEN=1 nom-build -A "pkgs.$name"
    }

    listPackages() {
      local outPath=$(nix profile list --json | jq -r '.elements."home-manager-path".storePaths[0]')
      nix-store -q --references "$outPath" | sed 's/[^-]*-//' | sort --ignore-case
    }

    showOption() {
      nixos-option \
        --options_expr "(import ./default.nix).options" \
        --config_expr "(import ./default.nix).config" \
        "$@"
    }

    updatePackage() {
      local name="$1"; shift

      nix-update "pkgs.$name" "$@"
    }

    copyPackage() {
      local src="$1"
      local dst="$2"

      cp -Tr ${pkgs.path}/pkgs/$src pkgs/$dst
      chmod -R +w pkgs
    }
  '';
}

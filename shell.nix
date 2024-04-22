let
  sources = import ./nix;

  pkgs = import sources.nixpkgs {};
in pkgs.mkShell {
  buildInputs = with pkgs; [
    gitMinimal
    nix-output-monitor
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

      nom-build -A "pkgs.$name"
    }
  '';
}

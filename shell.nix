let
  sources = import ./nix;

  pkgs = import sources.nixpkgs {};
in pkgs.mkShell {
  buildInputs = with pkgs; [
    nix-output-monitor
  ];

  shellHook = ''
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
  '';
}

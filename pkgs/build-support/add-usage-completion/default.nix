{ stdenvNoCC

, usage

, writeText
}:
let
  setupHook = writeText "setup-hook" ''
    addUsageCompletion() {
      local baseName="$1"
      local destDir="$2"
      local usageCmd="$3"

      _doSubstitute() {
        local completionsFile="$1"
        local destFile="$2"

        substitute "$completionsFile" "$destFile" \
          --subst-var-by exeName  "$baseName" \
          --subst-var-by baseName "''${baseName//-/_}" \
          --subst-var-by usageBin "${usage}/bin/usage" \
          --subst-var-by usageCmd "$usageCmd"
      }

      _doSubstitute ${./completions.bash} "$destDir/$baseName.bash"
      _doSubstitute ${./completions.zsh} "$destDir/_$baseName"
      _doSubstitute ${./completions.fish} "$destDir/$baseName.fish"
    }
  '';
in stdenvNoCC.mkDerivation {
  name = "add-usage-completion";

  buildCommand = ''
    mkdir -p $out/nix-support
    substituteAll ${setupHook} $out/nix-support/setup-hook
  '';
}

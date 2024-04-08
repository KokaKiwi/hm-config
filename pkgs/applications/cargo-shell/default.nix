{ lib

, fetchFromGitLab

, rustPlatform
}:
let
  baseVersion = "0.1.0";
  rev = "a75033c8fb53e65ff74856ddbcc7ef7bd3b3f715";
in rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = lib.gitVersion baseVersion rev;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    inherit rev;
    hash = "sha256-RwLXAloNOPQ0LEGpE3/xlsfKdxWYA3QH9JGYhdpgD44=";
  };

  cargoHash = "sha256-HaxrEZ86EwKeYj8AWuASReQlQ9oVNUxvbVSEOSSNquo=";

  meta = {
    mainProgram = "cargo-shell";
  };
}

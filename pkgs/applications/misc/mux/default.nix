{ lib

, fetchFromGitLab

, makeWrapper
, rustPlatform

, tmux
}:
rustPlatform.buildRustPackage {
  pname = "mux";
  version = "0.1-unstable-2024-10-08";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "mux";
    rev = "8fd46d75cdcdaa30e03b56dd90b8c096de7fbc25";
    hash = "sha256-wPDxpSF9mUDVrsY2Snj0pDUKdHs0eNMc7NchLBfRRRY=";
  };

  cargoHash = "sha256-LOElqAwolmtycFbhhnVqT+cVpe34zyOs7ij5lf46gJI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mux \
      --prefix PATH ":" ${lib.makeBinPath [ tmux ]}
  '';

  meta = {
    mainProgram = "mux";
  };
}

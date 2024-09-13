{ lib

, fetchFromGitLab

, makeWrapper
, rustPlatform

, tmux
}:
rustPlatform.buildRustPackage {
  pname = "mux";
  version = "0.1.10-unstable-2024-04-12";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "mux";
    rev = "ef15f6d1adb505349b86af356590ea138521b9e8";
    hash = "sha256-ngT9N6DMp5/TJSP1/387N8YxnOpYU9JGF9P1axeu15w=";
  };

  cargoHash = "sha256-YKcNsv6cMrBDqo+mM96MICGv4fI9trinzhpLtOvD0uo=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mux \
      --prefix PATH ":" ${lib.makeBinPath [ tmux ]}
  '';

  meta = {
    mainProgram = "mux";
  };
}

{ lib

, fetchFromGitLab

, makeWrapper
, rustPlatform

, tmux
}:
let
  version = "0.1.10";
  rev = "ef15f6d1adb505349b86af356590ea138521b9e8";
in rustPlatform.buildRustPackage {
  pname = "mux";
  version = lib.gitVersion version rev;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "mux";
    inherit rev;
    hash = "sha256-ngT9N6DMp5/TJSP1/387N8YxnOpYU9JGF9P1axeu15w=";
  };

  cargoHash = "sha256-YtQRC0xkCjJs/VM/PGJAeBT2OtQ1Pyv1OwOJGO1JC7k=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mux \
      --prefix PATH ":" ${lib.makeBinPath [ tmux ]}
  '';

  meta = {
    mainProgram = "mux";
  };
}

{ lib

, fetchFromGitHub

, installShellFiles
, addUsageCompletion
, rustPlatform

, bash
, coreutils
, direnv
, pkg-config
, openssl
}: rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2024.10.9";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-Gh/uskpCNAHB/Frdbggm1O6C3Et0beF5xoEOJtk2Oaw=";
  };

  cargoHash = "sha256-PR4cxs3P6xbPrVzN+swI+3wliA3oaIVjgxwwlWPkhis=";

  nativeBuildInputs = [ addUsageCompletion installShellFiles pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/reshim.rs \
      ./test/cwd/.mise/tasks/filetask

    substituteInPlace ./src/env_diff.rs \
      --replace-warn '"bash"' '"${bash}/bin/bash"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-warn '"env"' '"${coreutils}/bin/env"' \
      --replace-warn 'cmd!("direnv"' 'cmd!("${direnv}/bin/direnv"'
  '';

  doCheck = false;
  cargoTestFlags = [ "--all-features" ];
  useNextest = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    addUsageCompletion "mise" ./completions "$out/bin/mise usage"

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise
  '';

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "The front-end to your dev env";
    changelog = "https://github.com/jdx/mise/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "mise";
  };
}

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
  version = "2024.8.5";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-p10romVXP3sLV6geVjsCXjR+eOxkyd9LIaAanraCenY=";
  };

  cargoHash = "sha256-HK5ItTd1GIAOaoIHBIWEgAVcmJIiI666yyp2VLtFxKE=";

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

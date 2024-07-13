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
  version = "2024.7.2";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-+pA/lSY05+DET/l6rJ9H0V7y0re/9X5a0M7jWVOvmH0=";
  };

  cargoHash = "sha256-MP2GENUcBsI2c/W90pm4V5rdwGsW8F7toP755diAsYQ=";

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

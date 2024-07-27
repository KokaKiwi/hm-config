{ lib

, fetchFromGitHub

, rustPlatform
, installShellFiles

, cmake
, git
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-Y7jX0XXrSMEex1HG0o69Q1rTtnFL0UuIEgfa1e7D1Nc=";
  };

  cargoHash = "sha256-yJ32HFaRpujJ9mQa+07b5cQcl1ATO/56dpm1IeKcbzs=";

  nativeBuildInputs = [ installShellFiles cmake ];

  postInstall = ''
    installShellCompletion --cmd starship \
      --bash <($out/bin/starship completions bash) \
      --fish <($out/bin/starship completions fish) \
      --zsh <($out/bin/starship completions zsh)

    presetdir=$out/share/starship/presets/
    mkdir -p $presetdir
    cp docs/public/presets/toml/*.toml $presetdir
  '';

  nativeCheckInputs = [ git ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  passthru.tests = {
    inherit (nixosTests) starship;
  };

  meta = with lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    mainProgram = "starship";
  };
}

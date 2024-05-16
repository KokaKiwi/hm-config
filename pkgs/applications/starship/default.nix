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
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-3IO9hHuhzJsCHU/6BA5ylEKQI2ik6ZiRul/iO/vzii4=";
  };

  cargoHash = "sha256-zX04gX40dFYsK+R6gafHNtDevzrWiGufMwrGfhqYVG0=";

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

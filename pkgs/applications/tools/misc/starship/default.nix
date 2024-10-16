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
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    hash = "sha256-Xn9qV26/ST+3VtVq6OJP823lIVIo0zEdno+nIUv8B9c=";
  };

  cargoHash = "sha256-YbZCe2OcX/wq0OWvWK61nWvRT0O+CyW0QY0J7vv6QaM=";

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

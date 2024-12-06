{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QPCYKlbPHuSBmwfkKdYhcVF81Lnirf65IYao7UVxz9Q=";
  };

  cargoHash = "sha256-vtceKtYU8Jslk0PnQD/kGPFO4tDOp0TMYDFqkLy4j6U=";

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  meta = with lib; {
    description = "Build tool for the Leptos web framework";
    mainProgram = "cargo-leptos";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}

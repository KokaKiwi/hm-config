{ pkgs, ... }:
let
  makepkg = pkgs.writeShellScript "makepkg" ''
    export CUSTOMIZEPKG_CONFIG="$HOME/.config/customizepkg"

    _pkgname=$(basename $(pwd))

    # TODO: Replace with Nix-provided utilities
    if ! grep -s "## $0 ##" PKGBUILD >/dev/null && test -f "$CUSTOMIZEPKG_CONFIG/$_pkgname"; then
      /usr/bin/customizepkg --modify >&2

      echo "\n## $0 ##" >> PKGBUILD
    fi

    exec /usr/bin/makepkg "$@"
  '';
in {
  programs.paru = {
    enable = true;
    package = pkgs.nur.repos.kokakiwi.paru.override {
      rustPlatform = pkgs.fenixStableRustPlatform;
    };

    extraSettings = ''
      [options]
      BottomUp
      SudoLoop
      CleanAfter
      NoCheck
      CombinedUpgrade
      BatchInstall
      UpgradeMenu
      SkipReview
      SaveChanges

      [bin]
      Makepkg = ${makepkg}
      # Pacman = /usr/bin/pacman
    '';
  };
}

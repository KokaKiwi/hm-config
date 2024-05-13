{ pkgs, ... }:
let
  build-package-expr = "{ ... }@args: (import <nixpkgs> {}).callPackage ./default.nix args";
in {
  programs.fish = {
    package = pkgs.fish;

    functions = {
      copy = ''
        if test (count $argv) -ge 1
          cat $argv[1]
        else
          cat
        end | ${pkgs.wl-clipboard}/bin/wl-copy -n -t text/plain
      '';

      issh = {
        body = ''
          ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $argv
        '';
        wraps = "ssh";
      };
      rssh = {
        body = ''
          ssh -t $argv -- sudo -s
        '';
        wraps = "ssh";
      };

      nix-repl = {
        body = ''
          nix repl --expr "import <nixpkgs> {}" $argv
        '';
        wraps = "nix repl";
      };

      nix-build-package = {
        body = ''
          nix-build --expr "${build-package-expr}" $argv
        '';
        wraps = "nix-build";
      };

      nom-build-package = {
        body = ''
          nom-build --expr "${build-package-expr}" $argv
        '';
        wraps = "nix-build";
      };
    };

    completions = {
      batman = ''complete batman --wraps "man"'';
    };

    shellAbbrs = {
      man = "batman";

      systemctl = "systemctl --user";
      journalctl = "journalctl --user";
    };

    # Fix weird stuff with babelfish generation
    shellInit = ''
      function resetup_hm_session_vars
        set -q __hm_sess_vars_sourced_fish; and return
        set -g __hm_sess_vars_sourced_fish 1
        set __HM_SESS_VARS_SOURCED ""; setup_hm_session_vars
      end
      resetup_hm_session_vars
    '';

    interactiveShellInit = ''
      set fish_greeting

      source /etc/profile.d/nix-daemon.fish

      ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
    '';
  };
}

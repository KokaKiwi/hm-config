{ config, pkgs, ... }:
let
  tmuxCfg = config.programs.tmux;
in {
  programs.mux.package = pkgs.mux.override {
    tmux = tmuxCfg.package;
  };
}

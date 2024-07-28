{ pkgs, ... }:
{
  programs.litecli = {
    enable = true;
    package = let
      python = pkgs.python312;
    in pkgs.litecli.override {
      python3Packages = python.pkgs;
    };

    config = {
      main = {
        syntax_style = "monokai-dark";
        less_chatty = true;
      };
    };
  };
}

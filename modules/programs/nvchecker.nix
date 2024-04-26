{ pkgs, ... }:
{
  programs.nvchecker = {
    package = let
      python = pkgs.python312;
      nvchecker = python.pkgs.nvchecker;
    in nvchecker.overridePythonAttrs (super: {
      propagatedBuildInputs =
        super.propagatedBuildInputs
        ++ nvchecker.optional-dependencies.pypi;
    });
  };
}

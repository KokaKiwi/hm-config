{ pkgs, callPackage }:
{
  neovim = callPackage ./neovim {
    llvmPackages = pkgs.llvmPackages_latest;
    lua = pkgs.luajit;
  };
}

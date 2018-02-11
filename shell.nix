let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;

  haskellEnv = pkgs.haskell.packages.ghc822.ghcWithPackages
      (haskellPackages: with haskellPackages; [
        # libraries
        pandoc
      ]);

in with pkgs; {
  myProject = stdenv.mkDerivation {
    name = "retirement";
    version = "1";
    src = if pkgs.lib.inNixShell then null else nix;

    buildInputs = with rPackages; [
      R
      tidyverse
      RPostgreSQL
      codetools
      haskellEnv
      gnumake
      postgresql ];
  };
}

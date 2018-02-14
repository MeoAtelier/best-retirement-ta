{ mkDerivation, aeson, base, blaze-markup, blaze-svg, bytestring
, colour, double-conversion, filepath, palette, postgresql-simple
, stdenv, unordered-containers
}:
mkDerivation {
  pname = "graphics";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base blaze-markup blaze-svg bytestring colour
    double-conversion filepath palette postgresql-simple
    unordered-containers
  ];
  license = stdenv.lib.licenses.bsd3;
}

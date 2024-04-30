{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "smapi-compat";
  version = "1";

  src = ./src;

  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  meta = with lib; {
    description = "Steam Compatibility Tool to launch SMAPI.";
    license = licenses.unlicense;
    platforms = platforms.all;
  };
}

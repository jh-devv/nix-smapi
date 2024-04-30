{
  lib,
  stdenvNoCC,
  fetchzip,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "smapi";
  version = "4.0.8";
  owner = "Pathoschild";

  src = fetchzip {
    url = "https://github.com/${owner}/${pname}/releases/download/${version}/SMAPI-${version}-installer.zip";
    hash = "sha256-xdHjtn8zJw9h2pGk5vAYXwOpA7BnDYC3InoLEk99/ac=";
  };

  unpackPhase = "${lib.getExe unzip} $src/internal/linux/install.dat";

  dontConfigure = true;
  dontBuild = true;

  dontPatch = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  portInstall = ''
    rm -rf $out/steam_appid.txt
  '';

  meta = with lib; {
    description = "The modding API for Stardew Valley.";
    homepage = "https://github.com/Pathoschild/SMAPI";
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}

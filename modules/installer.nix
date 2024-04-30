{
  cfg,
  pkgs,
  lib,
  homeDirectory,
  ...
}:
with lib;
with builtins; let
  installDirectory = "${homeDirectory}/${cfg.path}";
  installDirectoryCompat = "${homeDirectory}/${cfg.compat.path}";

  packageContent = attrNames (readDir cfg.package);
  packageContentCompat = attrNames (readDir cfg.compat.package);

  copySnippet =
    ''mkdir -p ${installDirectoryCompat}''
    + "\n"
    + concatStringsSep "\n" (map (key: ''cp -ur "${cfg.package}/${key}" "${installDirectory}"'') packageContent)
    + "\n"
    + concatStringsSep "\n" (map (key: ''cp -ur "${cfg.compat.package}/${key}" "${installDirectoryCompat}"'') packageContentCompat);

  permissionSnippet =
    concatStringsSep "\n"
    (map (key: ''chmod -R 755 "${installDirectory}/${key}"'') packageContent)
    + "\n"
    + ''chmod -R 755 "${installDirectoryCompat}"'';

  deleteSnippet =
    concatStringsSep "\n"
    (map (key: ''rm -rf "${installDirectory}/${key}"'') packageContent)
    + "\n"
    + ''rm -rf ${installDirectoryCompat}'';

  snippet =
    if cfg.enable
    then ''
      if [ -d "${installDirectory}" ]; then
      ${copySnippet}
      ${permissionSnippet}
      fi
    ''
    else ''
      if [ -d "${installDirectory}/Mods" ]; then
      ${deleteSnippet}
      fi
    '';
in
  pkgs.writeShellScript "nix-smapi-managed-install" snippet

{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    overlayAttrs = {
      inherit (config.packages) smapi smapi-compat;
    };
    packages = {
      smapi = pkgs.callPackage ./smapi {};
      smapi-compat = pkgs.callPackage ./smapi-compat {};
    };
  };
}

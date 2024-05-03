{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      check.enable = true;
      settings.excludes = ["flake.lock"];
      settings.hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        prettier.enable = true;
        statix.enable = true;
        nil.enable = true;
      };
    };
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [git];
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
    formatter = pkgs.alejandra;
  };
}

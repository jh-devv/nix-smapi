self: {
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.programs.smapi;
in {
  options.programs.smapi = {
    enable = mkEnableOption "SMAPI, The mod loader for Stardew Valley";

    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.smapi;
      description = ''
        The package for SMAPI.
        By default, this is derived from the [SMAPI release](https://github.com/Pathoschild/SMAPI/releases) tar.gz `/internal/linux/install.dat`.
      '';
    };

    path = mkOption {
      type = types.str;

      default = ".local/share/Steam/steamapps/common/Stardew Valley";
      description = ''
        The location of your Stardew Valley game files in your local user directory.
      '';
    };

    compat = {
      package = mkOption {
        type = types.package;
        default = self.packages.${pkgs.system}.smapi-compat;
        description = ''
          The package for SMAPI steam compat tool. Used to load SMAPI.
        '';
      };
      path = mkOption {
        type = types.str;
        default = ".local/share/Steam/compatibilitytools.d/${cfg.compat.package.pname}";
        description = ''
          The location of your Stardew Valley game files in your local user directory.
        '';
      };
    };
  };

  config = {
    systemd.user.services."nix-smapi-managed-install" = {
      Service = {
        Type = "oneshot";
        ExecStart = import ./installer.nix {
          inherit cfg pkgs lib;
          inherit (config.home) homeDirectory;
        };
      };
    };

    home.activation = {
      nix-smapi-managed-install = lib.hm.dag.entryAfter ["reloadSystemd"] ''
        export PATH=${lib.makeBinPath (with pkgs; [systemd])}:$PATH
        export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/bus
        $DRY_RUN_CMD systemctl is-system-running -q && \
          systemctl --user start nix-smapi-managed-install.service || true
      '';
    };
  };
}

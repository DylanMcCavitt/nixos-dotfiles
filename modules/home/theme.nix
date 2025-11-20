{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.my.theme;
in {
  options.my.theme = {
    name = mkOption {
      type = types.enum ["gruvbox" "catppuccin"];
      default = "gruvbox";
      description = "global theme";
    };
  };

  config = {
    home.sessionVariables.THEME = cfg.name;
  };
}

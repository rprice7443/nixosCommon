{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.applications.enable {
    programs.joplin-desktop = {
      enable = true;
    };
  };
}

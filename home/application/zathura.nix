{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.applications.enable {
    programs.zathura = {
      enable = true;
    };
  };
}

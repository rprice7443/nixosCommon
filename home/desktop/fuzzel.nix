{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.linuxDesktop.enable {
    home.packages = [ pkgs.fuzzel ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.linuxDesktop.enable {
    programs.zathura = {
      enable = true;
    };
  };
}

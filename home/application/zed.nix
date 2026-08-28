{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.applications.enable {
    programs.zed-editor = {
      enable = true;
      installRemoteServer = true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.cli.enable {
    programs.git.enable = true;
  };
}

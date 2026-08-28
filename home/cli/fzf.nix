{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.cli.enable {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}

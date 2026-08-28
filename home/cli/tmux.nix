{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.cli.enable {
    programs.tmux = {
      enable = true;
      historyLimit = 5000;
      escapeTime = 0;
    };
  };
}

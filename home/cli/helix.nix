{ config, lib, ... }:
{
  config = lib.mkIf config.common.cli.enable {
    programs.helix.enable = true;
  };
}

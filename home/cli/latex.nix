{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.cli.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-small; };
    };
  };
}

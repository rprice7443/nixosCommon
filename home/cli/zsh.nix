{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.common.cli.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initContent = ''
        source "$HOME/.config/zsh/rc.zsh"
        source "$HOME/.config/zsh/hostrc.zsh"
      '';
    };
  };
}

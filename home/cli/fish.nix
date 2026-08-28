{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fish = {
    enable = true;
    preferAbbrs = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source
      atuin init fish | source
      direnv hook fish | source
      mise activate fish | source
    '';
    shellAbbrs = {
      "gac" = "git add . && git commit -m";
      "gps" = "git push";
      "ssr" = "sudo systemctl restart";
      "jfu" = "journalctl -f -u";
      "nfu" = "nix flake update";
      "ndd" = "nix develop .#";
      "opc" = "opencode";
      "zlj" = "zellij";
    };
  };

  home.packages =
    (with pkgs; [
      fishPlugins.done
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      fishPlugins.grc
      grc
    ])
    # fzf-fish is currently marked broken on darwin in nixpkgs.
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.fishPlugins.fzf-fish ];
}

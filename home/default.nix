{ self }:
{ config, lib, ... }:
let
  colors = (import ./colors.nix).tokyoNight;

  # Recursively enumerate all files under a directory, returning relative paths.
  listFilesRecursive =
    dir:
    let
      entries = builtins.readDir dir;
      process =
        name: type:
        if type == "directory" then
          map (f: "${name}/${f}") (listFilesRecursive "${dir}/${name}")
        else
          [ name ];
    in
    lib.flatten (lib.mapAttrsToList process entries);

  processFile =
    path:
    let
      content = builtins.readFile path;
      keys = builtins.attrNames colors;
    in
    builtins.replaceStrings (map (k: "@${k}@") keys) (map (k: colors.${k}) keys) content;

  # Which common.* flag gates each top-level xdgConfig/ subdirectory. Unlisted
  # directories deploy unconditionally. Applies to every source layer (src,
  # flakeSrc, hostSrc).
  xdgGates = {
    git = config.common.cli.enable;
    helix = config.common.cli.enable;
    zsh = config.common.cli.enable;
    fuzzel = config.common.linuxDesktop.enable;
    kanshi = config.common.linuxDesktop.enable;
    mako = config.common.linuxDesktop.enable;
    niri = config.common.linuxDesktop.enable;
    swaylock = config.common.linuxDesktop.enable;
    waybar = config.common.linuxDesktop.enable;
  };

  fileEnabled = f: xdgGates.${builtins.head (lib.splitString "/" f)} or true;

  # Build a xdg.configFile attrset from a home/xdgConfig/ directory inside src.
  xdgFiles =
    src:
    let
      xdgDir = "${src}/home/xdgConfig";
    in
    lib.listToAttrs (
      map (f: {
        name = f;
        value = {
          text = processFile "${xdgDir}/${f}";
        };
      }) (lib.filter fileEnabled (listFilesRecursive xdgDir))
    );
in
{
  imports = [
    ./packages.nix
    ./cli/git.nix
    ./cli/zsh.nix
    ./cli/helix.nix
    ./cli/tmux.nix
    ./cli/fzf.nix
    ./cli/latex.nix
    ./cli/fish.nix
    ./application/zed.nix
    ./application/joplin.nix
    ./application/zathura.nix
    ./desktop/niri.nix
    ./desktop/mako.nix
    ./desktop/fuzzel.nix
  ];

  options.common = {
    src = lib.mkOption {
      type = lib.types.path;
      default = self;
      description = "Path to the nixos-common flake source. Defaults to this flake; only override for unusual setups.";
    };
    flakeSrc = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a flake-level source tree containing a home/xdgConfig/ subdirectory, shared by every host defined in a consumer flake. Files here override those from src.";
    };
    hostSrc = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a host-specific source tree containing a home/xdgConfig/ subdirectory (conventionally ./hosts/<host-name> in a consumer flake). Files here override those from src and flakeSrc.";
    };
    packages.enable = lib.mkEnableOption "standard home packages";
    cli.enable = lib.mkEnableOption "common CLI tools (zsh, helix, tmux, fzf, latex)";
    applications.enable = lib.mkEnableOption "common GUI applications (vscode, zed, joplin, zathura)";
    linuxDesktop.enable = lib.mkEnableOption ''
      Linux graphical desktop: GUI applications (firefox, chromium,
      signal-desktop, ...) and Wayland desktop tooling (niri, waybar, mako,
      fuzzel). Linux-only; leave off for headless Linux and on darwin.'';
  };

  config = {
    xdg.configFile =
      let
        # Ordered by increasing precedence; later sources override earlier
        # ones per relative file path.
        sources = lib.filter (s: s != null && builtins.pathExists "${s}/home/xdgConfig") [
          config.common.src
          config.common.flakeSrc
          config.common.hostSrc
        ];
      in
      lib.foldl' (acc: s: acc // xdgFiles s) { } sources;

    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}

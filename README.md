# nixos-common

This nix flake is meant to be a common kernel for rprice7443's nixos and nix
home-manager configurations.

To promote re-usability (eg, between home and work configs), actual
nixosConfigurations and home-manager configurations are purposefully not defined
in this repository. Instead, a basic set of packages, modules, and options
are provided with the hope of making setup in a specific personal or work flake
straightforward.

## xdgConfig layering

The home module deploys files from up to three `xdgConfig/` trees, merged per
relative file path with later levels overriding earlier ones wholesale:

1. `common.src` — this flake's `xdgConfig/` (the default; includes common
   defaults and `@color@` substitution machinery).
2. `common.flakeSrc` — a tree shared by every host defined in a consumer
   flake.
3. `common.hostSrc` — a tree for one specific host.

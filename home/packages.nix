{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Cross-platform CLI / dev tooling — every platform, including headless
    # Linux and darwin.
    (lib.mkIf config.common.packages.enable {
      home.packages =
        (with pkgs; [
          # Terminal mainstays
          atuin
          gh
          bat
          btop
          git
          git-lfs
          helix
          tree
          unzip
          picocom
          lazygit
          jq
          ripgrep
          starship
          tmux

          # Shell
          oh-my-zsh
          zsh

          # Development
          cargo
          clang
          gopls
          forgejo-cli
          go
          just
          julia_110
          mise
          nasm
          nodejs
          rust-analyzer
          uv
          cachix
          zls
          k9s
          python3
          grpcurl
          openssl
          dig

          # Media and files
          ffmpeg
          xz

          # Security and secrets
          gnupg
          sops
          ssh-to-age

          # System and networking
          arp-scan
          nh
          rainfrog
          sshpass
          kubectl
          taplo
          jaq
          tcpdump
          tshark
        ])
        # Non-GUI Linux-only tooling — fine on headless Linux, absent on darwin.
        ++ lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            acpi
            bpftools
            nftables
            ethtool
            stun
            traceroute
          ]
        );
    })

    # Linux graphical desktop — GUI applications and Wayland tooling. Linux-only
    # by design; left off for headless Linux and on darwin.
    (lib.mkIf config.common.linuxDesktop.enable {
      home.packages = with pkgs; [
        # Browsers
        firefox
        chromium

        # Communication
        signal-desktop

        # GUI apps / editors / terminal
        ghostty
        pavucontrol
        pulsemixer
        blueman
        thunar

        # Wayland desktop
        kanshi
        slurp
        sway
        swaybg
        swaylock
        waypipe
        wdisplays
        xwayland-satellite
      ];
    })
  ];
}

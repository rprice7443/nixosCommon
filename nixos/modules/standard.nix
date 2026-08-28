{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.common = {
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "America/Los_Angeles";
      description = "System timezone.";
    };
    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Default system locale.";
    };
    docker.enable = lib.mkEnableOption "Docker";
    libvirt.enable = lib.mkEnableOption "libvirtd and QEMU virtualization";
    audio.enable = lib.mkEnableOption "PipeWire audio";
    printing.enable = lib.mkEnableOption "printing support";
    openssh.enable = lib.mkEnableOption "OpenSSH server";
    fish.enable = lib.mkEnableOption "fish shell with bash auto-exec into fish";
  };

  config = lib.mkMerge [
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      nix.optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };

      time.timeZone = config.common.timezone;
      i18n.defaultLocale = config.common.locale;

      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          liberation_ttf
          nerd-fonts.jetbrains-mono
        ];
        fontconfig = {
          defaultFonts = {
            sansSerif = [
              "Noto Sans"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Noto Sans CJK JP"
              "Noto Sans CJK KR"
            ];
            serif = [
              "Noto Serif"
              "Noto Serif CJK SC"
              "Noto Serif CJK TC"
              "Noto Serif CJK JP"
              "Noto Serif CJK KR"
            ];
            monospace = [
              "JetBrainsMono Nerd Font"
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono CJK TC"
              "Noto Sans Mono CJK JP"
              "Noto Sans Mono CJK KR"
            ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
      security.polkit.enable = true;
      hardware.graphics.enable = true;
      services.envfs.enable = true;

      programs.xwayland.enable = true;
      programs.mosh.enable = true;
      programs.zsh.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
        networkmanagerapplet
      ];

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc
          stdenv.cc.cc.lib
          zlib
          openssl
          glib
          fuse
          nss
          nspr
          dbus
          atk
          at-spi2-atk
          at-spi2-core
          libxkbcommon
          cups
          libdrm
          gtk3
          pango
          cairo
          libX11
          libXt
          libXcomposite
          libXdamage
          libXext
          libXfixes
          libXrandr
          libxcb
          mesa
          libgbm
          libGL
          expat
          libxkbfile
          libXtst
          alsa-lib
          udev
        ];
      };
    }

    (lib.mkIf config.common.openssh.enable {
      services.openssh = {
        enable = true;
        settings.X11Forwarding = true;
      };
    })

    (lib.mkIf config.common.fish.enable {
      programs.fish.enable = true;
      programs.bash.interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    })

    (lib.mkIf config.common.audio.enable {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })

    (lib.mkIf config.common.printing.enable {
      services.printing.enable = true;
    })

    (lib.mkIf config.common.docker.enable {
      virtualisation.docker.enable = true;
    })

    (lib.mkIf config.common.libvirt.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
    })
  ];
}

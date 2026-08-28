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
    fish.enable = lib.mkEnableOption "fish shell";
  };

  config = lib.mkMerge [
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # nix-darwin drives gc/optimise via launchd StartCalendarInterval attrsets,
      # not the systemd "dates" strings used by the NixOS module.
      nix.gc = {
        automatic = true;
        interval = {
          Weekday = 7;
          Hour = 3;
          Minute = 15;
        };
        options = "--delete-older-than 30d";
      };

      nix.optimise = {
        automatic = true;
        interval = {
          Weekday = 7;
          Hour = 4;
          Minute = 15;
        };
      };

      time.timeZone = config.common.timezone;

      # darwin has no fonts.enableDefaultPackages / fonts.fontconfig; only fonts.packages.
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        liberation_ttf
        nerd-fonts.jetbrains-mono
      ];
    }

    (lib.mkIf config.common.fish.enable {
      programs.fish.enable = true;
    })
  ];
}

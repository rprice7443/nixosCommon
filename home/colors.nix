let
  bare = c: builtins.substring 1 (builtins.stringLength c - 1) c;
  fuzzelFmt = c: "${bare c}ff";
  withAlpha = c: a: "#${bare c}${a}";

  tokyoNight = rec {
    background = "#1a1b26";
    surface = "#24283b";
    overlay = "#414868";
    comment = "#565f89";
    foreground = "#c0caf5";
    blue = "#7aa2f7";
    purple = "#bb9af7";
    cyan = "#7dcfff";
    green = "#9ece6a";
    yellow = "#e0af68";
    red = "#f7768e";

    background-fuzzel = fuzzelFmt background;
    foreground-fuzzel = fuzzelFmt foreground;
    blue-fuzzel = fuzzelFmt blue;
    surface-fuzzel = fuzzelFmt surface;
    overlay-fuzzel = fuzzelFmt overlay;

    background-alpha = withAlpha background "cc";

    background-rgba-92 = "rgba(26, 27, 38, 0.92)";
    blue-rgba-15 = "rgba(122, 162, 247, 0.15)";
    blue-rgba-20 = "rgba(122, 162, 247, 0.2)";
    red-rgba-20 = "rgba(247, 118, 142, 0.2)";

    background-bare = bare background;
    surface-bare = bare surface;
    blue-bare = bare blue;
    purple-bare = bare purple;
    green-bare = bare green;
    red-bare = bare red;
    foreground-bare = bare foreground;
  };
in
{
  inherit tokyoNight;
}

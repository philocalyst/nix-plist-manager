{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  plistPath = pathLib.generatePath true false "com.apple.wallpaper";
in
{
  systemWallpaperURL = rec {
    path = [
      "Wallpaper"
      "System Wallpaper URL"
    ];
    description = "The file path to the system wallpaper. Logic handles file:// prefix and space encoding.";

    mapping =
      let
        optionName = "SystemWallpaperURL";
      in
      {
        "unset" = {
          command = commandsLib.defaults.delete plistPath optionName;
        };
        "value" = {
          command =
            value:
            let
              # Encode spaces for URL compatibility
              encoded = lib.replaceStrings [ " " ] [ "%20" ] value;
              # Ensure file:// prefix exists
              url = if lib.hasPrefix "file://" encoded then encoded else "file://${encoded}";
            in
            commandsLib.defaults.write plistPath optionName "string" url;
        };
      };

    default = null;

    option = lib.mkOption {
      inherit description default;
      type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.enum [ "unset" ]));
    };

    config = {
      perUser = true;
      command = configLib.commandNullOrValueOrUnset mapping;
    };
  };
}

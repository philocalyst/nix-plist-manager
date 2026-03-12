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
    description = "";

    mapping =
      let
        optionName = "SystemWallpaperURL";
      in
      {
        "unset" = {
          command = commandsLib.defaults.delete plistPath optionName;
        };
        "value" = {
          command = value: commandsLib.defaults.write plistPath optionName "string" value;
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

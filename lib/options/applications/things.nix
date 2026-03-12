{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  # Things 3 uses a Group Container with a Team ID prefix that can change between installs.
  # The path resolves at activation time via shell glob.
  thingsPath = pathLib.generateGroupContainerPath "com.culturedcode.ThingsMac";

  mkBool = key: abstractionsLib.mkBasicBoolOption {
    path = thingsPath;
    default = null;
    perUser = true;
    unsetCommand = commandsLib.defaults.delete thingsPath key;
    trueCommand = commandsLib.defaults.write thingsPath key "bool" "true";
    falseCommand = commandsLib.defaults.write thingsPath key "bool" "false";
  };
in
{
  general = {
    todayWidgetCanLaunchThings = mkBool "todayWidgetCanLaunchThings" // {
      path = [
        "Things"
        "General"
        "Today widget can launch Things"
      ];
    };

    thingsCloudEverUsed = mkBool "thingsCloudEverUsed" // {
      path = [
        "Things"
        "General"
        "Things Cloud ever used"
      ];
    };
  };
}

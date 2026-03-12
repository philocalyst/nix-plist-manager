{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  plistPath = pathLib.generatePath true false "com.jordanbaird.Ice";

  mkBool = key: abstractionsLib.mkBasicBoolOption {
    path = plistPath;
    default = null;
    perUser = true;
    unsetCommand = commandsLib.defaults.delete plistPath key;
    trueCommand = commandsLib.defaults.write plistPath key "bool" "true";
    falseCommand = commandsLib.defaults.write plistPath key "bool" "false";
  };
in
{
  general = {
    showIceIcon = mkBool "ShowIceIcon" // {
      path = [
        "Ice"
        "General"
        "Show Ice Icon"
      ];
    };

    showSectionDividers = mkBool "ShowSectionDividers" // {
      path = [
        "Ice"
        "General"
        "Show Section Dividers"
      ];
    };

    enableAlwaysHiddenSection = mkBool "EnableAlwaysHiddenSection" // {
      path = [
        "Ice"
        "General"
        "Enable Always Hidden Section"
      ];
    };

    canToggleAlwaysHiddenSection = mkBool "CanToggleAlwaysHiddenSection" // {
      path = [
        "Ice"
        "General"
        "Can Toggle Always Hidden Section"
      ];
    };

    iceBarLocation = abstractionsLib.mkBasicMappingOption {
      default = null;
      perUser = true;
      path = [
        "Ice"
        "General"
        "Ice Bar Location"
      ];
      mapping =
        let
          optionName = "IceBarLocation";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "Dynamic" = {
            command = commandsLib.defaults.write plistPath optionName "int" "0";
          };
          "Static" = {
            command = commandsLib.defaults.write plistPath optionName "int" "1";
          };
        };
    };

    useIceBar = mkBool "UseIceBar" // {
      path = [
        "Ice"
        "General"
        "Use Ice Bar"
      ];
    };

    itemSpacingOffset = rec {
      path = [
        "Ice"
        "General"
        "Item Spacing Offset"
      ];
      description = "";
      mapping = let optionName = "ItemSpacingOffset"; in {
        "unset" = { command = commandsLib.defaults.delete plistPath optionName; };
        "value" = { command = value: commandsLib.defaults.write plistPath optionName "int" (toString value); };
      };
      default = null;
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrIntsBetweenOrUnset 0 20;
      };
      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };
  };

  behavior = {
    showOnClick = mkBool "ShowOnClick" // {
      path = [
        "Ice"
        "Behavior"
        "Show On Click"
      ];
    };

    showOnHover = mkBool "ShowOnHover" // {
      path = [
        "Ice"
        "Behavior"
        "Show On Hover"
      ];
    };

    showOnHoverDelay = rec {
      path = [
        "Ice"
        "Behavior"
        "Show On Hover Delay"
      ];
      description = "";
      mapping = let optionName = "ShowOnHoverDelay"; in {
        "unset" = { command = commandsLib.defaults.delete plistPath optionName; };
        "value" = { command = value: commandsLib.defaults.write plistPath optionName "float" (toString value); };
      };
      default = null;
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrFloatsBetweenOrUnset 0.0 5.0;
      };
      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };

    showOnScroll = mkBool "ShowOnScroll" // {
      path = [
        "Ice"
        "Behavior"
        "Show On Scroll"
      ];
    };

    showAllSectionsOnUserDrag = mkBool "ShowAllSectionsOnUserDrag" // {
      path = [
        "Ice"
        "Behavior"
        "Show All Sections On User Drag"
      ];
    };

    autoRehide = mkBool "AutoRehide" // {
      path = [
        "Ice"
        "Behavior"
        "Auto Rehide"
      ];
    };

    rehideInterval = rec {
      path = [
        "Ice"
        "Behavior"
        "Rehide Interval"
      ];
      description = "";
      mapping = let optionName = "RehideInterval"; in {
        "unset" = { command = commandsLib.defaults.delete plistPath optionName; };
        "value" = { command = value: commandsLib.defaults.write plistPath optionName "int" (toString value); };
      };
      default = null;
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrIntsBetweenOrUnset 1 120;
      };
      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };

    rehideStrategy = abstractionsLib.mkBasicMappingOption {
      default = null;
      perUser = true;
      path = [
        "Ice"
        "Behavior"
        "Rehide Strategy"
      ];
      mapping =
        let
          optionName = "RehideStrategy";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "Timed" = {
            command = commandsLib.defaults.write plistPath optionName "int" "0";
          };
          "Focus Change" = {
            command = commandsLib.defaults.write plistPath optionName "int" "1";
          };
        };
    };

    tempShowInterval = rec {
      path = [
        "Ice"
        "Behavior"
        "Temp Show Interval"
      ];
      description = "";
      mapping = let optionName = "TempShowInterval"; in {
        "unset" = { command = commandsLib.defaults.delete plistPath optionName; };
        "value" = { command = value: commandsLib.defaults.write plistPath optionName "int" (toString value); };
      };
      default = null;
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrIntsBetweenOrUnset 1 120;
      };
      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };
  };

  menuBar = {
    hideApplicationMenus = mkBool "HideApplicationMenus" // {
      path = [
        "Ice"
        "Menu Bar"
        "Hide Application Menus"
      ];
    };
  };
}

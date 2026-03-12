{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  iCalPath = pathLib.generatePath true false "com.apple.iCal";

  mkBool = plistPath: key: abstractionsLib.mkBasicBoolOption {
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
    calendarSidebarShown = mkBool iCalPath "CalendarSidebarShown" // {
      path = [
        "Calendar"
        "General"
        "Calendar Sidebar Shown"
      ];
    };

    timeZoneSupportEnabled = mkBool iCalPath "TimeZone support enabled" // {
      path = [
        "Calendar"
        "General"
        "Time Zone Support Enabled"
      ];
    };

    defaultCalendar = abstractionsLib.mkBasicMappingOption {
      default = null;
      perUser = true;
      path = [
        "Calendar"
        "General"
        "Default Calendar"
      ];
      mapping =
        let
          optionName = "CalDefaultCalendar";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete iCalPath optionName;
          };
          "Use Last Selected" = {
            command = commandsLib.defaults.write iCalPath optionName "string" "UseLastSelectedAsDefaultCalendar";
          };
        };
    };

    firstDayOfWeek = abstractionsLib.mkBasicMappingOption {
      default = null;
      perUser = true;
      path = [
        "Calendar"
        "General"
        "First Day of Week"
      ];
      mapping =
        let
          optionName = "first day of week";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete iCalPath optionName;
          };
          "Sunday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "1";
          };
          "Monday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "2";
          };
          "Tuesday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "3";
          };
          "Wednesday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "4";
          };
          "Thursday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "5";
          };
          "Friday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "6";
          };
          "Saturday" = {
            command = commandsLib.defaults.write iCalPath optionName "int" "7";
          };
        };
    };
  };

  dayView = {
    firstMinuteOfDayTimeRange = rec {
      path = [
        "Calendar"
        "Day View"
        "First Minute of Day Time Range"
      ];
      description = "";

      mapping =
        let
          optionName = "first minute of day time range";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete iCalPath optionName;
          };
          "value" = {
            command =
              value:
              commandsLib.defaults.write iCalPath optionName "int" "${toString value}";
          };
        };

      default = null;

      option = lib.mkOption {
        inherit description default;
        type =
          let
            minValue = 0;
            maxValue = 1440;
          in
          typesLib.nullOrIntsBetweenOrUnset minValue maxValue;
      };

      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };

    lastMinuteOfDayTimeRange = rec {
      path = [
        "Calendar"
        "Day View"
        "Last Minute of Day Time Range"
      ];
      description = "";

      mapping =
        let
          optionName = "last minute of day time range";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete iCalPath optionName;
          };
          "value" = {
            command =
              value:
              commandsLib.defaults.write iCalPath optionName "int" "${toString value}";
          };
        };

      default = null;

      option = lib.mkOption {
        inherit description default;
        type =
          let
            minValue = 0;
            maxValue = 1440;
          in
          typesLib.nullOrIntsBetweenOrUnset minValue maxValue;
      };

      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };
  };

  advanced = {
    enableTravelAdvisories = mkBool iCalPath "enableTravelAdvisoriesForAutomaticBehavior" // {
      path = [
        "Calendar"
        "Advanced"
        "Enable Travel Advisories"
      ];
    };
  };
}

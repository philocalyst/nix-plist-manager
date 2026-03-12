{ lib, commandsLib, typesLib, configLib, pathLib, abstractionsLib }:
{
  softwareUpdate = {
    automaticallyDownloadNewUpdatesWhenAvailable =
      let
        plistPath = "/Library/Preferences/com.apple.SoftwareUpdate";
        optionName = "AutomaticDownload";
      in
      abstractionsLib.mkBasicBoolOption {
        path = [
          "System Settings"
          "General"
          "Software Update"
          "Download new updates when available"
        ];
        default = null;
        perUser = false;
        unsetCommand = commandsLib.defaults.delete plistPath optionName;
        trueCommand = commandsLib.defaults.write plistPath optionName "bool" "true";
        falseCommand = commandsLib.defaults.write plistPath optionName "bool" "false";
      };

    automaticallyInstallMacOSUpdates =
      let
        plistPath = "/Library/Preferences/com.apple.SoftwareUpdate";
        optionName = "AutomaticallyInstallMacOSUpdates";
      in
      abstractionsLib.mkBasicBoolOption {
        path = [
          "System Settings"
          "General"
          "Software Update"
          "Install macOS updates"
        ];
        default = null;
        perUser = false;
        unsetCommand = commandsLib.defaults.delete plistPath optionName;
        trueCommand = commandsLib.defaults.write plistPath optionName "bool" "true";
        falseCommand = commandsLib.defaults.write plistPath optionName "bool" "false";
      };

    automaticallyInstallApplicationUpdatesFromTheAppStore =
      let
        plistPath = "/Library/Preferences/com.apple.commerce";
        optionName = "AutoUpdate";
      in
      abstractionsLib.mkBasicBoolOption {
        path = [
          "System Settings"
          "General"
          "Software Update"
          "Install application updates from the App Store"
        ];
        default = null;
        perUser = false;
        unsetCommand = commandsLib.defaults.delete plistPath optionName;
        trueCommand = commandsLib.defaults.write plistPath optionName "bool" "true";
        falseCommand = commandsLib.defaults.write plistPath optionName "bool" "false";
      };

    automaticallyInstallSecurityResponseAndSystemFiles =
      let
        plistPath = "/Library/Preferences/com.apple.SoftwareUpdate";
        optionName = "CriticalUpdateInstall";
      in
      abstractionsLib.mkBasicBoolOption {
        path = [
          "System Settings"
          "General"
          "Software Update"
          "Install Security Response and system files"
        ];
        default = null;
        perUser = false;
        unsetCommand = commandsLib.defaults.delete plistPath optionName;
        trueCommand = commandsLib.defaults.write plistPath optionName "bool" "true";
        falseCommand = commandsLib.defaults.write plistPath optionName "bool" "false";
      };
  };

  dateAndTime = {
    # TODO setTimeAndDateAutomatically
    # TODO source
    # TODO dateAndTime
    "24HourTime" =
      let
        plistPath = pathLib.generatePath true true ".GlobalPreferences";
        optionName = "AppleICUForce24HourTime";
      in
      abstractionsLib.mkBasicBoolOption {
        path = [
          "System"
          "Date & Time"
          "24-hour time"
        ];
        default = null;
        perUser = true;
        unsetCommand = commandsLib.defaults.delete plistPath optionName;
        trueCommand = commandsLib.defaults.write plistPath optionName "bool" "true";
        falseCommand = commandsLib.defaults.write plistPath optionName "bool" "false";
      };
    # TODO show24HourTimeOnLockScreen
    # TODO setTimeZoneAutomaticallyUsingCurrentLocation
    # TODO timeZone
    # TODO closestCity
  };
}

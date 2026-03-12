{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  plistPath = pathLib.generatePath true false "com.apple.Music";

  mkBool = key:
    abstractionsLib.mkBasicBoolOption {
      path = plistPath;
      default = null;
      perUser = true;
      unsetCommand = commandsLib.defaults.delete plistPath key;
      trueCommand = commandsLib.defaults.write plistPath key "bool" "true";
      falseCommand = commandsLib.defaults.write plistPath key "bool" "false";
    };
in
{
  playback = {
    crossfadeEnabled = mkBool "crossfadeEnabled" // {
      path = [
        "Music"
        "Playback"
        "Crossfade Enabled"
      ];
    };

    crossfadeSeconds = rec {
      path = [
        "Music"
        "Playback"
        "Crossfade Seconds"
      ];
      description = "";

      mapping =
        let
          optionName = "crossfadeSeconds";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "value" = {
            command =
              value:
              commandsLib.defaults.write plistPath optionName "int" "${toString value}";
          };
        };

      default = null;

      option = lib.mkOption {
        inherit description default;
        type =
          let
            minValue = 1;
            maxValue = 12;
          in
          typesLib.nullOrIntsBetweenOrUnset minValue maxValue;
      };

      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };

    losslessEnabled = mkBool "losslessEnabled" // {
      path = [
        "Music"
        "Playback"
        "Lossless Enabled"
      ];
    };

    preferredDolbyAtmosPlaySetting = abstractionsLib.mkBasicMappingOption {
      path = [
        "Music"
        "Playback"
        "Preferred Dolby Atmos Play Setting"
      ];
      default = null;
      perUser = true;
      mapping =
        let
          optionName = "preferredDolbyAtmosPlaySetting";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "Automatic" = {
            command = commandsLib.defaults.write plistPath optionName "int" "20";
          };
          "Always On" = {
            command = commandsLib.defaults.write plistPath optionName "int" "21";
          };
          "Off" = {
            command = commandsLib.defaults.write plistPath optionName "int" "22";
          };
        };
    };

    audioPassthroughSetting = abstractionsLib.mkBasicMappingOption {
      path = [
        "Music"
        "Playback"
        "Audio Passthrough Setting"
      ];
      default = null;
      perUser = true;
      mapping =
        let
          optionName = "audioPassthroughSetting";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "Off" = {
            command = commandsLib.defaults.write plistPath optionName "int" "0";
          };
          "Enabled" = {
            command = commandsLib.defaults.write plistPath optionName "int" "1";
          };
        };
    };
  };

  general = {
    automaticallyDownloadArtwork = mkBool "automaticallyDownloadArtwork" // {
      path = [
        "Music"
        "General"
        "Automatically Download Artwork"
      ];
    };
  };

  downloads = {
    userMaxConcurrentDownloads = rec {
      path = [
        "Music"
        "Downloads"
        "User Max Concurrent Downloads"
      ];
      description = "";

      mapping =
        let
          optionName = "userMaxConcurrentDownloads";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete plistPath optionName;
          };
          "value" = {
            command =
              value:
              commandsLib.defaults.write plistPath optionName "int" "${toString value}";
          };
        };

      default = null;

      option = lib.mkOption {
        inherit description default;
        type =
          let
            minValue = 1;
            maxValue = 10;
          in
          typesLib.nullOrIntsBetweenOrUnset minValue maxValue;
      };

      config = {
        perUser = true;
        command = configLib.commandNullOrValueOrUnset mapping;
      };
    };
  };
}

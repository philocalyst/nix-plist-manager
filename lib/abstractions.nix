# abstractions.nix
{
  lib,
  commandsLib,
  pathLib,
  typesLib,
  configLib,
}:
{
  mkBasicBoolOption =
    {
      path,
      default,
      perUser,
      unsetCommand,
      trueCommand,
      falseCommand,
    }:
    rec {
      inherit path;
      description = "";
      mapping = {
        "unset".command = unsetCommand;
        "true".command = trueCommand;
        "false".command = falseCommand;
      };
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrBoolOrUnset;
      };
      config = {
        inherit perUser;
        command = configLib.commandNullOrBoolOrUnset mapping;
      };
    };

  mkBasicIntOption =
    {
      path,
      default,
      perUser,
      unsetCommand,
      setCommand,
    }:
    rec {
      inherit path;
      description = "";
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrInt;
      };
      config = {
        inherit perUser;
        command = configLib.commandNullOrInt unsetCommand setCommand;
      };
    };

  mkBasicMappingOption =
    {
      path,
      default,
      perUser,
      mapping,
    }:
    rec {
      inherit path mapping;
      description = "";
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrMapping mapping;
      };
      config = {
        inherit perUser;
        command = configLib.commandMapping mapping;
      };
    };

  # Writes a bool to multiple PlistBuddy key-paths simultaneously.
  # Pass `invert = true` to flip true/false (for settings where the plist
  # semantics are opposite to the user-facing label).
  mkMultiPlistBuddyBoolOption =
    {
      path,
      default,
      perUser,
      plistFile,
      keyPaths,
      invert ? false,
    }:
    let
      cmds =
        value: map (kp: commandsLib.plistBuddy.set plistFile kp "bool" (lib.boolToString value)) keyPaths;
      deleteCmds = map (kp: commandsLib.plistBuddy.delete plistFile kp) keyPaths;
    in
    rec {
      inherit path;
      description = "";
      mapping = {
        "unset".command = deleteCmds;
        "true".command = cmds (!invert);
        "false".command = cmds invert;
      };
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrBoolOrUnset;
      };
      config = {
        inherit perUser;
        command = configLib.commandNullOrBoolOrUnset mapping;
      };
    };

  # Writes an integer to multiple PlistBuddy key-paths simultaneously.
  mkMultiPlistBuddyIntOption =
    {
      path,
      default,
      perUser,
      plistFile,
      keyPaths,
    }:
    rec {
      inherit path;
      description = "";
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrInt;
      };
      config = {
        inherit perUser;
        command =
          configLib.commandNullOrInt (map (kp: commandsLib.plistBuddy.delete plistFile kp) keyPaths)
            (value: map (kp: commandsLib.plistBuddy.set plistFile kp "integer" (toString value)) keyPaths);
      };
    };

  # Writes a string mapping to multiple PlistBuddy key-paths simultaneously.
  # mapping shape: { "Label" = { value = "rawString"; }; "unset" = { unset = true; }; }
  mkMultiPlistBuddyMappingOption =
    {
      path,
      default,
      perUser,
      plistFile,
      keyPaths,
      mapping,
    }:
    let
      deleteCmds = map (kp: commandsLib.plistBuddy.delete plistFile kp) keyPaths;
      resolvedMapping = lib.mapAttrs (_name: entry: {
        command =
          if entry ? unset && entry.unset then
            deleteCmds
          else
            map (kp: commandsLib.plistBuddy.set plistFile kp "string" entry.value) keyPaths;
      }) mapping;
    in
    rec {
      inherit path;
      description = "";
      mapping = resolvedMapping;
      option = lib.mkOption {
        inherit description default;
        type = typesLib.nullOrMapping resolvedMapping;
      };
      config = {
        inherit perUser;
        command = configLib.commandMapping resolvedMapping;
      };
    };
}

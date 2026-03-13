{
  lib,
  commandsLib,
  configLib,
  pathLib,
  typesLib,
  abstractionsLib,
}:
let
  globalPreferencesPath = pathLib.generatePath true false ".GlobalPreferences";
  finderPath = pathLib.generatePath true true "com.apple.finder";
  birdPath = pathLib.generatePath true true "com.apple.bird";

  # The three IconViewSettings subtrees that MUST stay in sync
  iconViewKeyPaths =
    key:
    map (prefix: "${prefix}:IconViewSettings:${key}") [
      ":DesktopViewSettings"
      ":FK_StandardViewSettings"
      ":StandardViewSettings"
    ];

  mkBool =
    path: plistPath: key:
    abstractionsLib.mkBasicBoolOption {
      inherit path;
      default = null;
      perUser = true;
      unsetCommand = commandsLib.defaults.delete plistPath key;
      trueCommand = commandsLib.defaults.write plistPath key "bool" "true";
      falseCommand = commandsLib.defaults.write plistPath key "bool" "false";
    };

  mkBoolInverted =
    path: plistPath: key:
    abstractionsLib.mkBasicBoolOption {
      inherit path;
      default = null;
      perUser = true;
      unsetCommand = commandsLib.defaults.delete plistPath key;
      trueCommand = commandsLib.defaults.write plistPath key "bool" "false";
      falseCommand = commandsLib.defaults.write plistPath key "bool" "true";
    };

  mkMapping =
    path: mapping:
    abstractionsLib.mkBasicMappingOption {
      inherit path mapping;
      default = null;
      perUser = true;
    };

  mkIconViewBool =
    path: key:
    abstractionsLib.mkMultiPlistBuddyBoolOption {
      inherit path;
      plistFile = finderPath;
      keyPaths = iconViewKeyPaths key;
      default = null;
      perUser = true;
    };

  mkIconViewInt =
    path: key:
    abstractionsLib.mkMultiPlistBuddyIntOption {
      inherit path;
      plistFile = finderPath;
      keyPaths = iconViewKeyPaths key;
      default = null;
      perUser = true;
    };

  mkIconViewMapping =
    path: key: mapping:
    abstractionsLib.mkMultiPlistBuddyMappingOption {
      inherit path mapping;
      plistFile = finderPath;
      keyPaths = iconViewKeyPaths key;
      default = null;
      perUser = true;
    };
in
{
  settings = {
    general = {
      showTheseItemsOnTheDesktop = {
        hardDisks = mkBool [
          "Finder"
          "Settings"
          "General"
          "Show these items on the desktop"
          "Hard disks"
        ] finderPath "ShowHardDrivesOnDesktop";

        externalDisks = mkBool [
          "Finder"
          "Settings"
          "General"
          "Show these items on the desktop"
          "External disks"
        ] finderPath "ShowExternalHardDrivesOnDesktop";

        cdsDvdsAndiPods = mkBool [
          "Finder"
          "Settings"
          "General"
          "Show these items on the desktop"
          "CDs, DVDs, and iPods"
        ] finderPath "ShowRemovableMediaOnDesktop";

        connectedServers = mkBool [
          "Finder"
          "Settings"
          "General"
          "Show these items on the desktop"
          "Connected servers"
        ] finderPath "ShowMountedServersOnDesktop";
      };

      newFinderWindowTarget =
        let
          optionName = "NewWindowTarget";
        in
        mkMapping [ "Finder" "Settings" "General" "New Finder windows show" ] {
          "unset".command = commandsLib.defaults.delete finderPath optionName;
          "Computer".command = commandsLib.defaults.write finderPath optionName "string" "PfCm";
          "Home".command = commandsLib.defaults.write finderPath optionName "string" "PfHm";
          "Desktop".command = commandsLib.defaults.write finderPath optionName "string" "PfDe";
          "Documents".command = commandsLib.defaults.write finderPath optionName "string" "PfDo";
          "iCloud Drive".command = commandsLib.defaults.write finderPath optionName "string" "PfID";
          "Recents".command = commandsLib.defaults.write finderPath optionName "string" "PfAF";
          "Other".command = commandsLib.defaults.write finderPath optionName "string" "PfLo";
        };

      openFoldersInTabsInsteadOfNewWindows = mkBool [
        "Finder"
        "Settings"
        "General"
        "Open folders in tabs instead of new windows"
      ] finderPath "FinderSpawnTab";
    };

    sidebar = {
      recentTags = mkBool [
        "Finder"
        "Settings"
        "Sidebar"
        "Show Recent Tags"
      ] finderPath "ShowRecentTags";
    };

    advanced = {
      showAllFilenameExtensions = mkBool [
        "Finder"
        "Settings"
        "Advanced"
        "Show all filename extensions"
      ] globalPreferencesPath "AppleShowAllExtensions";

      showWarningBeforeChangingAnExtension = mkBool [
        "Finder"
        "Settings"
        "Advanced"
        "Show warning before changing an extension"
      ] finderPath "FXEnableExtensionChangeWarning";

      showWarningBeforeRemovingFromiCloudDrive = mkBoolInverted [
        "Finder"
        "Settings"
        "Advanced"
        "Show warning before removing from iCloud Drive"
      ] birdPath "FXEnableExtensionChangeWarning";

      showWarningBeforeEmptyingTheTrash = mkBool [
        "Finder"
        "Settings"
        "Advanced"
        "Show warning before emptying the Trash"
      ] finderPath "WarnOnEmptyTrash";

      removeItemsFromTheTrashAfter30Days = mkBool [
        "Finder"
        "Settings"
        "Advanced"
        "Remove items from the Trash after 30 days"
      ] finderPath "FXRemoveOldTrashItems";

      keepFoldersOnTop = {
        inWindowsWhenSortingByName = mkBool [
          "Finder"
          "Settings"
          "Advanced"
          "Keep folders on top"
          "In windows when sorting by name"
        ] finderPath "_FXSortFoldersFirst";

        onDesktop = mkBool [
          "Finder"
          "Settings"
          "Advanced"
          "Keep folders on top"
          "On Desktop"
        ] finderPath "_FXSortFoldersFirstOnDesktop";
      };

      whenPerformingASearch =
        let
          optionName = "FXDefaultSearchScope";
        in
        mkMapping [ "Finder" "Settings" "Advanced" "When performing a search" ] {
          "unset".command = commandsLib.defaults.delete finderPath optionName;
          "Search This Mac".command = commandsLib.defaults.write finderPath optionName "string" "SCev";
          "Search the Current Folder".command =
            commandsLib.defaults.write finderPath optionName "string"
              "SCcf";
          "Use the Previous Search Scope".command =
            commandsLib.defaults.write finderPath optionName "string"
              "SCsp";
        };

      groupBy =
        let
          optionName = "FXArrangeGroupViewBy";
        in
        mkMapping [ "Finder" "Settings" "Advanced" "Group by" ] {
          "unset".command = commandsLib.defaults.delete finderPath optionName;
          "Name".command = commandsLib.defaults.write finderPath optionName "string" "Name";
          "Kind".command = commandsLib.defaults.write finderPath optionName "string" "Kind";
          "Application".command = commandsLib.defaults.write finderPath optionName "string" "Application";
          "Date Last Opened".command =
            commandsLib.defaults.write finderPath optionName "string"
              "dateLastOpened";
          "Date Added".command = commandsLib.defaults.write finderPath optionName "string" "dateAdded";
          "Date Modified".command = commandsLib.defaults.write finderPath optionName "string" "dateModified";
          "Date Created".command = commandsLib.defaults.write finderPath optionName "string" "dateCreated";
          "Size".command = commandsLib.defaults.write finderPath optionName "string" "size";
          "Tags".command = commandsLib.defaults.write finderPath optionName "string" "label";
        };
    };
  };

  menuBar = {
    view = {
      showTabBar = mkBool [
        "Finder"
        "Menu Bar"
        "View"
        "Show Tab Bar"
      ] finderPath "NSWindowTabbingShoudShowTabBarKey-com.apple.finder.TBrowserWindow";

      showSidebar = mkBool [ "Finder" "Menu Bar" "View" "Show Sidebar" ] finderPath "ShowSidebar";

      showPathBar = mkBool [ "Finder" "Menu Bar" "View" "Show Path Bar" ] finderPath "ShowPathBar";

      showStatusBar = mkBool [ "Finder" "Menu Bar" "View" "Show Status Bar" ] finderPath "ShowStatusBar";
    };
  };

  preferences = {
    showHiddenFiles = mkBool [
      "Finder"
      "Preferences"
      "Show hidden files"
    ] finderPath "AppleShowAllFiles";

    showPosixPathInTitle = mkBool [
      "Finder"
      "Preferences"
      "Show POSIX path in title"
    ] finderPath "_FXShowPosixPathInTitle";

    preferredViewStyle =
      let
        optionName = "FXPreferredViewStyle";
      in
      mkMapping [ "Finder" "Preferences" "Preferred view style" ] {
        "unset".command = commandsLib.defaults.delete finderPath optionName;
        "Icon".command = commandsLib.defaults.write finderPath optionName "string" "icnv";
        "List".command = commandsLib.defaults.write finderPath optionName "string" "Nlsv";
        "Column".command = commandsLib.defaults.write finderPath optionName "string" "clmv";
        "Gallery".command = commandsLib.defaults.write finderPath optionName "string" "glyv";
      };

    createDesktop = mkBool [ "Finder" "Preferences" "Create Desktop" ] finderPath "CreateDesktop";

    quitMenuItem = mkBool [ "Finder" "Preferences" "Quit menu item" ] finderPath "QuitMenuItem";

    iCloudDriveDesktop = mkBool [
      "Finder"
      "Preferences"
      "iCloud Drive Desktop sync"
    ] finderPath "FXICloudDriveDesktop";

    iCloudDriveDocuments = mkBool [
      "Finder"
      "Preferences"
      "iCloud Drive Documents sync"
    ] finderPath "FXICloudDriveDocuments";

    iCloudDriveEnabled = mkBool [
      "Finder"
      "Preferences"
      "iCloud Drive enabled"
    ] finderPath "FXICloudDriveEnabled";

    iconView = {
      showItemInfo = mkIconViewBool [
        "Finder"
        "Preferences"
        "Icon View"
        "Show item info"
      ] "showItemInfo";

      labelOnBottom = mkIconViewBool [
        "Finder"
        "Preferences"
        "Icon View"
        "Label on bottom"
      ] "labelOnBottom";

      arrangeBy = mkIconViewMapping [ "Finder" "Preferences" "Icon View" "Arrange by" ] "arrangeBy" {
        "unset" = {
          unset = true;
        };
        "None" = {
          value = "none";
        };
        "Name" = {
          value = "name";
        };
        "Snap to Grid" = {
          value = "grid";
        };
        "Date Modified" = {
          value = "dateModified";
        };
        "Date Created" = {
          value = "dateCreated";
        };
        "Date Last Opened" = {
          value = "dateLastOpened";
        };
        "Date Added" = {
          value = "dateAdded";
        };
        "Size" = {
          value = "size";
        };
        "Kind" = {
          value = "kind";
        };
        "Tags" = {
          value = "label";
        };
      };

      gridSpacing = mkIconViewInt [ "Finder" "Preferences" "Icon View" "Grid spacing" ] "gridSpacing";

      iconSize = mkIconViewInt [ "Finder" "Preferences" "Icon View" "Icon size" ] "iconSize";
    };
  };
}

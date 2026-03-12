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

  mkBool = plistPath: key: abstractionsLib.mkBasicBoolOption {
    path = plistPath;
    default = null;
    perUser = true;
    unsetCommand = commandsLib.defaults.delete plistPath key;
    trueCommand = commandsLib.defaults.write plistPath key "bool" "true";
    falseCommand = commandsLib.defaults.write plistPath key "bool" "false";
  };

  mkBoolInverted = plistPath: key: abstractionsLib.mkBasicBoolOption {
    path = plistPath;
    default = null;
    perUser = true;
    unsetCommand = commandsLib.defaults.delete plistPath key;
    trueCommand = commandsLib.defaults.write plistPath key "bool" "false";
    falseCommand = commandsLib.defaults.write plistPath key "bool" "true";
  };
in
{
  settings = {
    general = {
      showTheseItemsOnTheDesktop = {
        hardDisks = mkBool finderPath "ShowHardDrivesOnDesktop" // {
          path = [
            "Finder"
            "Settings"
            "General"
            "Show these items on the desktop"
            "Hard disks"
          ];
        };

        externalDisks = mkBool finderPath "ShowExternalHardDrivesOnDesktop" // {
          path = [
            "Finder"
            "Settings"
            "General"
            "Show these items on the desktop"
            "External disks"
          ];
        };

        cdsDvdsAndiPods = mkBool finderPath "ShowRemovableMediaOnDesktop" // {
          path = [
            "Finder"
            "Settings"
            "General"
            "Show these items on the desktop"
            "CDs, DVDs, and iPods"
          ];
        };

        connectedServers = mkBool finderPath "ShowMountedServersOnDesktop" // {
          path = [
            "Finder"
            "Settings"
            "General"
            "Show these items on the desktop"
            "Connected servers"
          ];
        };
      };
      newFinderWindowTarget = abstractionsLib.mkBasicMappingOption {
        default = null;
        perUser = true;
        path = [
          "Finder"
          "Settings"
          "General"
          "New Finder windows show"
        ];
        mapping =
          let
            optionName = "NewWindowTarget";
          in
          {
            "unset" = {
              command = commandsLib.defaults.delete finderPath optionName;
            };
            "Computer" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfCm";
            };
            "Home" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfHm";
            };
            "Desktop" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfDe";
            };
            "Documents" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfDo";
            };
            "iCloud Drive" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfID";
            };
            "Recents" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfAF";
            };
            "Other" = {
              command = commandsLib.defaults.write finderPath optionName "string" "PfLo";
            };
          };
      };
      openFoldersInTabsInsteadOfNewWindows = mkBool finderPath "FinderSpawnTab" // {
        path = [
          "Finder"
          "Settings"
          "General"
          "Open folders in tabs instead of new windows"
        ];
      };
    };
    sidebar = {
      recentTags = mkBool finderPath "ShowRecentTags" // {
        path = [
          "Finder"
          "Settings"
          "Sidebar"
          "Show Recent Tags"
        ];
      };
    };
    advanced = {
      showAllFilenameExtensions = mkBool globalPreferencesPath "AppleShowAllExtensions" // {
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "Show all filename extensions"
        ];
      };

      showWarningBeforeChangingAnExtension = mkBool finderPath "FXEnableExtensionChangeWarning" // {
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "Show warning before changing an extension"
        ];
      };

      showWarningBeforeRemovingFromiCloudDrive = mkBoolInverted birdPath "FXEnableExtensionChangeWarning" // {
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "Show warning before removing from iCloud Drive"
        ];
      };

      showWarningBeforeEmptyingTheTrash = mkBool finderPath "WarnOnEmptyTrash" // {
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "Show warning before emptying the Trash"
        ];
      };

      removeItemsFromTheTrashAfter30Days = mkBool finderPath "FXRemoveOldTrashItems" // {
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "Remove items from the Trash after 30 days"
        ];
      };

      keepFoldersOnTop = {
        inWindowsWhenSortingByName = mkBool finderPath "_FXSortFoldersFirst" // {
          path = [
            "Finder"
            "Settings"
            "Advanced"
            "Keep folders on top"
            "In windows when sorting by name"
          ];
        };
        onDesktop = mkBool finderPath "_FXSortFoldersFirstOnDesktop" // {
          path = [
            "Finder"
            "Settings"
            "Advanced"
            "Keep folders on top"
            "On Desktop"
          ];
        };
      };

      whenPerformingASearch = abstractionsLib.mkBasicMappingOption {
        default = null;
        perUser = true;
        path = [
          "Finder"
          "Settings"
          "Advanced"
          "When performing a search"
        ];
        mapping =
          let
            optionName = "FXDefaultSearchScope";
          in
          {
            "unset" = {
              command = commandsLib.defaults.delete finderPath optionName;
            };
            "Search This Mac" = {
              command = commandsLib.defaults.write finderPath optionName "string" "SCev";
            };
            "Search the Current Folder" = {
              command = commandsLib.defaults.write finderPath optionName "string" "SCcf";
            };
            "Use the Previous Search Scope" = {
              command = commandsLib.defaults.write finderPath optionName "string" "SCsp";
            };
          };
      };
    };
  };
  menuBar = {
    view = {
      showTabBar = mkBool finderPath "NSWindowTabbingShoudShowTabBarKey-com.apple.finder.TBrowserWindow" // {
        path = [
          "Finder"
          "Menu Bar"
          "View"
          "Show Tab Bar"
        ];
      };

      showSidebar = mkBool finderPath "ShowSidebar" // {
        path = [
          "Finder"
          "Menu Bar"
          "View"
          "Show Sidebar"
        ];
      };

      showPathBar = mkBool finderPath "ShowPathBar" // {
        path = [
          "Finder"
          "Menu Bar"
          "View"
          "Show Path Bar"
        ];
      };

      showStatusBar = mkBool finderPath "ShowStatusBar" // {
        path = [
          "Finder"
          "Menu Bar"
          "View"
          "Show Status Bar"
        ];
      };
    };
  };
  preferences = {
    showHiddenFiles = mkBool finderPath "AppleShowAllFiles" // {
      path = [
        "Finder"
        "Preferences"
        "Show hidden files"
      ];
    };

    showPosixPathInTitle = mkBool finderPath "_FXShowPosixPathInTitle" // {
      path = [
        "Finder"
        "Preferences"
        "Show POSIX path in title"
      ];
    };

    preferredViewStyle = abstractionsLib.mkBasicMappingOption {
      default = null;
      perUser = true;
      path = [
        "Finder"
        "Preferences"
        "Preferred view style"
      ];
      mapping =
        let
          optionName = "FXPreferredViewStyle";
        in
        {
          "unset" = {
            command = commandsLib.defaults.delete finderPath optionName;
          };
          "Icon" = {
            command = commandsLib.defaults.write finderPath optionName "string" "icnv";
          };
          "List" = {
            command = commandsLib.defaults.write finderPath optionName "string" "Nlsv";
          };
          "Column" = {
            command = commandsLib.defaults.write finderPath optionName "string" "clmv";
          };
          "Gallery" = {
            command = commandsLib.defaults.write finderPath optionName "string" "glyv";
          };
        };
    };

    createDesktop = mkBool finderPath "CreateDesktop" // {
      path = [
        "Finder"
        "Preferences"
        "Create Desktop"
      ];
    };

    quitMenuItem = mkBool finderPath "QuitMenuItem" // {
      path = [
        "Finder"
        "Preferences"
        "Quit menu item"
      ];
    };

    iCloudDriveDesktop = mkBool finderPath "FXICloudDriveDesktop" // {
      path = [
        "Finder"
        "Preferences"
        "iCloud Drive Desktop sync"
      ];
    };

    iCloudDriveDocuments = mkBool finderPath "FXICloudDriveDocuments" // {
      path = [
        "Finder"
        "Preferences"
        "iCloud Drive Documents sync"
      ];
    };
  };
}

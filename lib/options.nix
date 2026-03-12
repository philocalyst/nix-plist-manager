{ lib }:
let
  commandsLib = import ./commands.nix { inherit lib; };
  typesLib = import ./types.nix { inherit lib; };
  configLib = import ./config.nix { inherit lib; };
  pathLib = import ./paths.nix { inherit lib; };
  abstractionsLib = import ../lib/abstractions.nix {
    inherit
      lib
      commandsLib
      pathLib
      typesLib
      configLib
      ;
  };
in
{
  applications =
    let
      allLibs = {
        inherit
          lib
          commandsLib
          typesLib
          configLib
          pathLib
          abstractionsLib
          ;
      };
    in
    {
      systemSettings = {
        general = import ./options/applications/systemSettings/general.nix allLibs;
        appearance = import ./options/applications/systemSettings/appearance.nix allLibs;
        controlCenter = import ./options/applications/systemSettings/control-center.nix allLibs;
        desktopAndDock = import ./options/applications/systemSettings/desktop-and-dock.nix allLibs;
        spotlight = import ./options/applications/systemSettings/spotlight.nix allLibs;
        notifications = import ./options/applications/systemSettings/notifications.nix allLibs;
        sound = import ./options/applications/systemSettings/sound.nix allLibs;
        focus = import ./options/applications/systemSettings/focus.nix allLibs;
      };
      finder = import ./options/applications/finder.nix allLibs;
    };
}

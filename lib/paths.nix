{ lib }:
{
  generatePath =
    perUser: byHost: name:
    let
      base = if perUser then "~/Library/Preferences" else "/Library/Preferences";
      hostPart = if byHost then "/ByHost" else "";
    in
    base + hostPart + "/" + name;

  # For apps using Group Containers where the Team ID prefix can change between installs.
  # Returns a shell expression (not a plain string) that resolves at activation time.
  generateGroupContainerPath =
    bundleIdentifier:
    ''"$(echo ~/Library/Group\ Containers/*.${bundleIdentifier}/Library/Preferences/*.${bundleIdentifier})"'';
}

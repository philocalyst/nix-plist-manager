{ lib }:
{
  defaults = {
    delete = path: optionName: "/usr/bin/defaults delete ${path} ${optionName} 2>/dev/null || true";
    write =
      path: optionName: type: value:
      ''/usr/bin/defaults write ${path} ${optionName} -${type} "${lib.escapeShellArg value}" 2>/dev/null || true'';
  };

  chainOnSuccess = " && \\\n";

  plistBuddy = {
    set =
      plistFile: keyPath: type: value:
      "/usr/libexec/PlistBuddy -c 'Set ${keyPath} ${value}' ${plistFile} 2>/dev/null || /usr/libexec/PlistBuddy -c 'Add ${keyPath} ${type} ${value}' ${plistFile} 2>/dev/null || true";
    delete =
      plistFile: keyPath:
      "/usr/libexec/PlistBuddy -c 'Delete ${keyPath}' ${plistFile} 2>/dev/null || true";
  };

  osaScript = script: "/usr/bin/osascript -e ${lib.escapeShellArg script} 2>/dev/null || true";

  notifyUtilPost =
    notification: "/usr/bin/notifyutil -p ${lib.escapeShellArg notification} 2>/dev/null || true";

  killall = processName: "/usr/bin/killall ${lib.escapeShellArg processName} 2>/dev/null || true";
}

#define MyAppVersion "3.3.2"

[Setup]
AppName=Skyrim After Dark Updater
AppVersion={#MyAppVersion}
AppPublisher=King Neogreen
DefaultDirName={autopf}\Skyrim After Dark
DefaultGroupName=Skyrim After Dark
AllowNoIcons=yes
OutputDir=H:\SAD-Updater
OutputBaseFilename=SkyrimAfterDark_Updater_v3.3.2
Compression=lzma2/ultra
SolidCompression=yes
UninstallDisplayIcon={app}\ModOrganizer.exe
UninstallDisplayName=Skyrim After Dark Uninstall


WizardStyle=modern
PrivilegesRequired=none
DisableDirPage=no
UsePreviousSetupType=False
UsePreviousTasks=False
FlatComponentsList=False
UsePreviousLanguage=False
RestartIfNeededByRun=no


[Types]
Name: "update"; Description: "Update Skyrim After Dark"; Check: FileExists(ExpandConstant('{src}\update.7z'))


[Components]
Name: "updater"; Description: "Update Core Files"; Check: FileExists(ExpandConstant('{src}\update.7z')); Types: update; Flags: exclusive


[Files]
Source: "H:\Installer-Project\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\7za.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\7zxa.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\changelog.txt"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\cleanup_update.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\removed_files.txt"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\create_changelog_ini.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall


[Run]
Filename: "{tmp}\cleanup_update.exe"; Parameters: """{app}"" ""{tmp}\removed_files.txt"""; WorkingDir: "{tmp}"; StatusMsg: "Cleaning up old mod files..."; Flags: runhidden waituntilterminated

Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\update.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Updating Skyrim After Dark..."; Components: updater; Flags: runhidden waituntilterminated

Filename: "{tmp}\create_changelog_ini.exe"; Parameters: """{app}\"" ""{tmp}\changelog.txt"" ""{#MyAppVersion}"""; WorkingDir: "{tmp}"; StatusMsg: "Creating Changelog file..."; Flags: runhidden waituntilterminated

Filename: "{sys}\cmd.exe"; Parameters: "/C del ""{tmp}\removed_files.txt"" & del ""{tmp}\cleanup_update.exe"" & del ""{tmp}\changelog.txt"" & del ""{tmp}\create_changelog_ini.exe"""; Flags: runhidden waituntilterminated

Filename: "{app}\ModOrganizer.exe"; Flags: nowait postinstall; Description: "Launch Skyrim After Dark Mod Organizer 2"
Filename: "notepad.exe"; Parameters: """{app}\Changes\changelog_v{#MyAppVersion}.ini"""; Flags: postinstall shellexec; Description: "View Changelog for v{#MyAppVersion}"


[Icons]
Name: "{group}\Mod Organizer 2 - Skyrim After Dark"; Filename: "{app}\ModOrganizer.exe"
Name: "{group}\Uninstall Skyrim After Dark"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Mod Organizer 2 - Skyrim After Dark"; Filename: "{app}\ModOrganizer.exe"; Tasks: desktopicon

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: checkedonce


[Messages]
SetupConfirmation=You are about to update Skyrim After Dark. Ensure your 'update.7z' is in the same folder as the updater.
InstallationAborted=Update aborted! Please ensure Skyrim Special Edition is installed and 'update.7z' exists.


[Code]
var
  SSEInstallationPath: string;

function InitializeSetup(): Boolean;
var
  Value: string;
begin
  Result := True;

  if not RegQueryStringValue(
    HKEY_LOCAL_MACHINE, 'SOFTWARE\Bethesda Softworks\Skyrim Special Edition',
    'Installed Path', Value) then
  begin
    MsgBox('Cannot find a Skyrim: Special Edition installation. Please run the game''s launcher at least once.', mbCriticalError, MB_OK);
    Result := False;
    exit;
  end;
  SSEInstallationPath := ExtractFileDir(Value);
  Log(Format('Skyrim: Special Edition is installed to %s', [SSEInstallationPath]));

  if not FileExists(ExpandConstant('{src}\update.7z')) then
  begin
    MsgBox('The update.7z file could not be found alongside the updater. Please ensure it is in the same directory as this updater executable.', mbCriticalError, MB_OK);
    Result := False;
    exit;
  end;

  Result := True;
end;

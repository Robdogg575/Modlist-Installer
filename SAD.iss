[Setup]
AppName=Skyrim After Dark
AppVersion=3.3.1
AppPublisher=King Neogreen
DefaultDirName={autopf}\Skyrim After Dark
DefaultGroupName=Skyrim After Dark
AllowNoIcons=yes
OutputDir=H:\SAD-Installer
OutputBaseFilename=SkyrimAfterDark_Installer
Compression=lzma2/ultra
SolidCompression=yes
SourceDir=H:\Installer-Project\Skyrim After Dark
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


[Files]
Source: "H:\Installer-Project\Skyrim After Dark\*"; DestDir: "{app}\"; Flags: ignoreversion recursesubdirs createallsubdirs

Source: "H:\Installer-Project\VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\7za.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\7zxa.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "H:\Installer-Project\LiamFootHash.exe"; DestDir: "{tmp}\LiamFootHash"; Flags: deleteafterinstall
Source: "H:\Installer-Project\create_stock_game.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall


[Run]
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /passive /norestart"; WorkingDir: "{tmp}"; StatusMsg: "Installing Microsoft Visual C++ Redistributable..."; Flags: waituntilterminated shellexec

Filename: "{tmp}\create_stock_game.exe"; Parameters: """{app}"""; WorkingDir: "{tmp}"; StatusMsg: "Creating Stock Game folder..."; Flags: runhidden waituntilterminated

Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\profiles.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Extracting profiles..."; Flags: runhidden waituntilterminated

Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\mods.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Extracting mod archives..."; Flags: runhidden waituntilterminated

Filename: "{tmp}\LiamFootHash\LiamFootHash.exe"; Parameters: """{app}\SAD-mods.lfhash"""; WorkingDir: "{app}"; StatusMsg: "Verifying mod files..."; Flags: waituntilterminated
Filename: "{tmp}\LiamFootHash\LiamFootHash.exe"; Parameters: """{app}\SAD-profiles.lfhash"""; WorkingDir: "{app}"; StatusMsg: "Verifying profile files..."; Flags: waituntilterminated


Filename: "{app}\ModOrganizer.exe"; Flags: nowait postinstall; Description: "Launch Skyrim After Dark Mod Organizer 2"


[Icons]
Name: "{group}\Mod Organizer 2 - Skyrim After Dark"; Filename: "{app}\ModOrganizer.exe"
Name: "{group}\Uninstall Skyrim After Dark"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Mod Organizer 2 - Skyrim After Dark"; Filename: "{app}\ModOrganizer.exe"; Tasks: desktopicon

[Tasks]
Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: checkedonce

[Messages]
SetupConfirmation=You are about to install Skyrim After Dark. Make sure you have enough disk space and your Skyrim Special Edition is installed.
InstallationAborted=Installation aborted! Please ensure Skyrim Special Edition is installed and try again.

[UninstallDelete]
Type: filesandordirs; Name: "{app}\mods"
Type: filesandordirs; Name: "{app}\profiles"
Type: filesandordirs; Name: "{app}\Stock Game"


[Code]
var
  SkyrimSEPath: String;

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
  SkyrimSEPath := ExtractFileDir(Value);
  Log(Format('Skyrim: Special Edition is installed to %s', [SkyrimSEPath]));
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectDir then
  begin
  end;
end;

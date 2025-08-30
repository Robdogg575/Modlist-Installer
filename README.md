# Automated Modlist Installer & Updater Guide

This guide provides step-by-step instructions for creating a custom installer and updater for a Mod Organizer 2 (MO2) modlist, using *Skyrim After Dark* as an example. It leverages Inno Setup and pre-compiled helper tools to package and distribute your modlist efficiently, with support for seamless updates. The process is divided into three phases: Preparation, Project Setup, and Script Compilation.

---

## Phase 1: Preparation and Essential Tools

Gather all necessary files and software to ensure a smooth setup process.

### 1.1 Essential Files for Your Modlist

The following files are required to build your modlist installer and updater:

- **Modlist Folder**: The complete MO2 instance folder containing `ModOrganizer.exe`, `ModOrganizer.ini`, and other MO2-related files (excluding `mods` and `profiles` folders). For *Skyrim After Dark*, this is `H:\Installer-Project\Skyrim After Dark`. Ensure `ModOrganizer.ini` uses **relative paths** (e.g., `mods\` instead of `C:\ModOrganizer\mods\`) to ensure compatibility across different systems.

- **mods.7z**: A .7z archive of your `mods` folder, compressed at **ultra compression** level using 7-Zip.

- **profiles.7z**: A .7z archive of your `profiles` folder, compressed at **ultra compression** level.

- **update.7z** (for updates only): A .7z archive containing files modified or added for a specific update, also compressed at **ultra compression** level.

- **removed_files.txt**: A plain text file listing files or folders to be removed during an update, with each entry on a new line, relative to the MO2 installation root (e.g., `mods/ObsoleteMod`). Example:
  ```
  mods/OldTextureMod
  files/old_enb.ini
  ```
  If no files need to be removed, create an empty `removed_files.txt`.

- **changelog.txt**: A plain text file detailing changes for the latest update, including version numbers and descriptions. Example:
  ```
  v3.3.2:
  - Added NewLightingMod
  - Removed OldENBPlugin
  - Updated NPC textures
  ```

- **Banner Images (Optional)**:
  - A large banner (164x314 pixels) in 24-bit BMP format for the installer/updater UI.
  - A small logo (55x58 pixels) in 24-bit BMP format for branding.

### 1.2 Required Software

Install the following software to compile and create your installer/updater:

- **Inno Setup Compiler**: Download from [jrsoftware.org](https://jrsoftware.org) to compile `.iss` scripts into executable installers.
- **7-Zip**: Download from [7-zip.org](https://7-zip.org) to create `.7z` archives for `mods`, `profiles`, and `update` folders.

### 1.3 Pre-Compiled Helper Tools

The following helper executables are provided with this guide’s source files and are essential for functionality:

- `create_changelog_ini.exe`: Generates a `changelog.ini` file from `changelog.txt` for display in the updater.
- `create_stock_game.exe`: Sets up a clean game environment (e.g., a `Stock Game` folder).
- `cleanup_update.exe`: Removes outdated files listed in `removed_files.txt` during updates.
- `7za.exe`, `7za.dll`, `7zxa.dll`: 7-Zip utilities for extracting `.7z` archives during installation.
- `LiamFootHash.exe`: Generates and verifies file hashes (e.g., `SAD-mods.lfhash`, `SAD-profiles.lfhash`) to ensure file integrity.
- `VC_redist.x64.exe`: Installs Microsoft Visual C++ Redistributable, required for some helper tools.

---

## Phase 2: Preparing Your Project Files

Set up your project folder with all required files and organize them correctly for compilation.

### 2.1 Project Folder Structure

Create a project folder (e.g., `H:\Installer-Project`) to hold all files needed for compilation. Based on the *Skyrim After Dark* example, the structure should be:

```
H:\Installer-Project\
├── Skyrim After Dark\              # Your MO2 modlist folder
│   ├── ModOrganizer.exe            # Core MO2 executable
│   ├── ModOrganizer.ini            # Config file with relative paths
│   └── [other MO2 files/folders]    # Exclude mods and profiles folders
├── 7za.dll                         # 7-Zip utility
├── 7za.exe                         # 7-Zip utility
├── 7zxa.dll                        # 7-Zip utility
├── changelog.txt                   # Changelog for the updater
├── cleanup_update.exe              # Update cleanup tool
├── create_changelog_ini.exe        # Changelog generator
├── create_stock_game.exe           # Stock game setup tool
├── LiamFootHash.exe                # File hash generator
├── removed_files.txt               # List of files to remove during updates
├── SAD.iss                         # Inno Setup script for the installer
├── updater.iss                     # Inno Setup script for the updater
└── VC_redist.x64.exe               # Visual C++ Redistributable
```

- **Skyrim After Dark Folder**: Contains your MO2 instance, excluding `mods` and `profiles` folders, which are archived into `mods.7z` and `profiles.7z`.
- **changelog.txt**: Example entries:
  ```
  v3.3.2:
  - Added NewLightingMod
  - Updated NPC textures
  - Removed OldENBPlugin
  ```
- **removed_files.txt**: Example entries:
  ```
  mods/OldENBPlugin
  files/old_enb.ini
  ```
- **SAD.iss and updater.iss**: Inno Setup script templates for the installer and updater, respectively.

### 2.2 Output Folders

After compilation, you will generate two separate output folders:

- **Installer Output Folder** (e.g., `H:\SAD-Installer`):
  ```
  H:\SAD-Installer\
  ├── mods.7z                     # Compressed mods folder
  ├── profiles.7z                 # Compressed profiles folder
  └── SkyrimAfterDark_Installer.exe  # Compiled installer executable
  ```

- **Updater Output Folder** (e.g., `H:\SAD-Updater`):
  ```
  H:\SAD-Updater\
  ├── update.7z                   # Compressed update files
  └── SkyrimAfterDark_Updater_v3.3.2.exe  # Compiled updater executable
  ```

**Important**: The `.7z` archives (`mods.7z`, `profiles.7z`, `update.7z`) are not included in the project folder during compilation. They must be manually placed in the respective output folders (`H:\SAD-Installer` or `H:\SAD-Updater`) alongside the compiled `.exe` files for the installer or updater to function.

---

## Phase 3: Modifying and Compiling Inno Setup Scripts

Customize the `SAD.iss` and `updater.iss` scripts and compile them using Inno Setup to create the installer and updater executables.

### 3.1 Customizing the Inno Setup Scripts

Modify the provided `.iss` scripts with your specific paths and modlist details.

#### 3.1.1 Editing SAD.iss (Installer Script)

The `SAD.iss` script compiles the main installer (e.g., `SkyrimAfterDark_Installer.exe`). Open it in a text editor and update the following sections:

- **AppName and AppVersion**: Set the modlist name and version:
  ```iss
  AppName=YourModlist
  AppVersion=3.3.2
  ```

- **AppPublisher**: Specify the publisher name:
  ```iss
  AppPublisher=YourName
  ```

- **DefaultDirName**: Set the default installation directory:
  ```iss
  DefaultDirName={autopf}\YourModlist
  ```

- **DefaultGroupName**: Set the Start menu group:
  ```iss
  DefaultGroupName=YourModlist
  ```

- **OutputDir**: Specify the output folder for the compiled installer:
  ```iss
  OutputDir=H:\SAD-Installer
  ```

- **OutputBaseFilename**: Set the installer executable name:
  ```iss
  OutputBaseFilename=YourModlist_Installer
  ```

- **SourceDir**: Set the root directory of your project folder:
  ```iss
  SourceDir=H:\Installer-Project\YourModlist
  ```

- **Source Files**: Update paths to match your project folder:
  ```iss
  Source: "H:\Installer-Project\YourModlist\*"; DestDir: "{app}\"; Flags: ignoreversion recursesubdirs createallsubdirs
  Source: "H:\Installer-Project\VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\7za.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\7zxa.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\LiamFootHash.exe"; DestDir: "{tmp}\LiamFootHash"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\create_stock_game.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  ```

- **Run Section**: Ensure commands match your setup:
  ```iss
  Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /passive /norestart"; WorkingDir: "{tmp}"; StatusMsg: "Installing Microsoft Visual C++ Redistributable..."; Flags: waituntilterminated shellexec
  Filename: "{tmp}\create_stock_game.exe"; Parameters: """{app}"""; WorkingDir: "{tmp}"; StatusMsg: "Creating Stock Game folder..."; Flags: runhidden waituntilterminated
  Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\mods.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Extracting mod archives..."; Flags: runhidden waituntilterminated
  Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\profiles.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Extracting profiles..."; Flags: runhidden waituntilterminated
  Filename: "{tmp}\LiamFootHash\LiamFootHash.exe"; Parameters: """{app}\YourModlist-mods.lfhash"""; WorkingDir: "{app}"; StatusMsg: "Verifying mod files..."; Flags: waituntilterminated
  Filename: "{tmp}\LiamFootHash\LiamFootHash.exe"; Parameters: """{app}\YourModlist-profiles.lfhash"""; WorkingDir: "{app}"; StatusMsg: "Verifying profile files..."; Flags: waituntilterminated
  Filename: "{app}\ModOrganizer.exe"; Flags: nowait postinstall; Description: "Launch YourModlist Mod Organizer 2"
  ```

- **Icons and Tasks**: Configure Start menu and desktop icons:
  ```iss
  [Icons]
  Name: "{group}\Mod Organizer 2 - YourModlist"; Filename: "{app}\ModOrganizer.exe"
  Name: "{group}\Uninstall YourModlist"; Filename: "{uninstallexe}"
  Name: "{commondesktop}\Mod Organizer 2 - YourModlist"; Filename: "{app}\ModOrganizer.exe"; Tasks: desktopicon

  [Tasks]
  Name: desktopicon; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: checkedonce
  ```

- **Code Section**: Verify the game installation (e.g., Skyrim Special Edition):
  ```iss
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
  ```

- **Banner Images (Optional)**: Update paths to your 24-bit BMP files:
  ```iss
  WizardImageFile=H:\Installer-Project\banner.bmp
  WizardSmallImageFile=H:\Installer-Project\logo.bmp
  ```

#### 3.1.2 Editing updater.iss (Updater Script)

The `updater.iss` script compiles the updater (e.g., `SkyrimAfterDark_Updater_v3.3.2.exe`). Update the following:

- **AppName and AppVersion**: Use a defined variable for the version:
  ```iss
  #define MyAppVersion "3.3.2"
  AppName=YourModlist Updater
  AppVersion={#MyAppVersion}
  ```

- **AppPublisher**: Specify the publisher name:
  ```iss
  AppPublisher=YourName
  ```

- **DefaultDirName**: Match the installer’s installation directory:
  ```iss
  DefaultDirName={autopf}\YourModlist
  ```

- **OutputDir**: Set the output folder for the updater:
  ```iss
  OutputDir=H:\SAD-Updater
  ```

- **OutputBaseFilename**: Set the updater executable name:
  ```iss
  OutputBaseFilename=YourModlist_Updater_v3.3.2
  ```

- **Source Files**: Include `update.7z` and helper tools:
  ```iss
  Source: "H:\Installer-Project\7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\7za.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\7zxa.dll"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\changelog.txt"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\cleanup_update.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\removed_files.txt"; DestDir: "{tmp}"; Flags: deleteafterinstall
  Source: "H:\Installer-Project\create_changelog_ini.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall
  ```

- **Types and Components**: Ensure the updater checks for `update.7z`:
  ```iss
  [Types]
  Name: "update"; Description: "Update YourModlist"; Check: FileExists(ExpandConstant('{src}\update.7z'))

  [Components]
  Name: "updater"; Description: "Update Core Files"; Check: FileExists(ExpandConstant('{src}\update.7z')); Types: update; Flags: exclusive
  ```

- **Run Section**: Include commands to apply the update:
  ```iss
  Filename: "{tmp}\cleanup_update.exe"; Parameters: """{app}"" ""{tmp}\removed_files.txt"""; WorkingDir: "{tmp}"; StatusMsg: "Cleaning up old mod files..."; Flags: runhidden waituntilterminated
  Filename: "{tmp}\7za.exe"; Parameters: "x ""{src}\update.7z"" -aoa -o""{app}\"" -y"; WorkingDir: "{app}"; StatusMsg: "Updating YourModlist..."; Components: updater; Flags: runhidden waituntilterminated
  Filename: "{tmp}\create_changelog_ini.exe"; Parameters: """{app}\"" ""{tmp}\changelog.txt"" ""{#MyAppVersion}"""; WorkingDir: "{tmp}"; StatusMsg: "Creating Changelog file..."; Flags: runhidden waituntilterminated
  Filename: "{sys}\cmd.exe"; Parameters: "/C del ""{tmp}\removed_files.txt"" & del ""{tmp}\cleanup_update.exe"" & del ""{tmp}\changelog.txt"" & del ""{tmp}\create_changelog_ini.exe"""; Flags: runhidden waituntilterminated
  Filename: "{app}\ModOrganizer.exe"; Flags: nowait postinstall; Description: "Launch YourModlist Mod Organizer 2"
  Filename: "notepad.exe"; Parameters: """{app}\Changes\changelog_v{#MyAppVersion}.ini"""; Flags: postinstall shellexec; Description: "View Changelog for v{#MyAppVersion}"
  ```

- **Code Section**: Verify the game and `update.7z`:
  ```iss
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
  ```

**Critical Note on Paths**: Replace example paths (e.g., `H:\Installer-Project\`) with your actual project folder paths. Incorrect paths will cause compilation or execution failures.

### 3.2 Creating update.7z for the Updater

The `update.7z` archive contains only the files changed or added in the update. To create it:

1. Identify modified, added, or removed files/folders since the last version.
2. Archive these files into `update.7z` using 7-Zip at **ultra compression** level.
3. Place `update.7z` in the updater output folder (e.g., `H:\SAD-Updater`) alongside `YourModlist_Updater_v3.3.2.exe`.

### 3.3 Compiling the Scripts

1. Open Inno Setup Compiler.
2. Load `SAD.iss` and click **Compile** to generate `YourModlist_Installer.exe` in `H:\SAD-Installer`.
3. Load `updater.iss` and click **Compile** to generate `YourModlist_Updater_v3.3.2.exe` in `H:\SAD-Updater`.
4. After compilation, copy `mods.7z` and `profiles.7z` to `H:\SAD-Installer`.
5. Copy `update.7z` to `H:\SAD-Updater`.

### 3.4 Testing the Installer and Updater

- **Installer**: Run `YourModlist_Installer.exe` to verify it:
  - Checks for the game installation (e.g., Skyrim Special Edition).
  - Installs the MO2 instance and extracts `mods.7z` and `profiles.7z`.
  - Creates a `Stock Game` folder using `create_stock_game.exe`.
  - Verifies file integrity using `LiamFootHash.exe`.
  - Creates Start menu and desktop icons (if selected).

- **Updater**: Run `YourModlist_Updater_v3.3.2.exe` to ensure it:
  - Checks for `update.7z`.
  - Removes files listed in `removed_files.txt` using `cleanup_update.exe`.
  - Extracts `update.7z` to apply changes.
  - Generates `changelog_v3.3.2.ini` in the `Changes` folder using `create_changelog_ini.exe`.
  - Opens the changelog in Notepad post-installation.
  - Launches MO2 post-update (optional).

---

## Additional Notes

- **Relative Paths in ModOrganizer.ini**: Double-check that all paths in `ModOrganizer.ini` are relative to avoid issues on different systems.
- **File Integrity**: `LiamFootHash.exe` ensures file integrity by generating/verifying `.lfhash` files (e.g., `YourModlist-mods.lfhash`). Do not remove it from the project folder.
- **Versioning**: Ensure the `#define MyAppVersion` in `updater.iss` matches `changelog.txt` for consistency.
- **Distribution**: Share the entire `H:\SAD-Installer` and `H:\SAD-Updater` folders with users, ensuring `.7z` files are included with the respective `.exe` files.
- **Game Dependency Check**: The `[Code]` sections in both scripts check for the game’s installation (e.g., Skyrim Special Edition). Update the registry key if targeting a different game:
  ```iss
  RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Bethesda Softworks\Skyrim Special Edition', 'Installed Path', Value)
  ```
- **Troubleshooting**: If the installer/updater fails, verify:
  - All paths in `.iss` scripts are correct.
  - `.7z` files are in the correct output folders.
  - `ModOrganizer.ini` uses relative paths.
  - The game is installed and its registry key is valid.

This guide, tailored to the *Skyrim After Dark* example, provides a robust framework for creating an installer and updater for your MO2 modlist, ensuring a seamless experience for users.

; Stremio Kai (AshmitW fork) installer.
; Built by .github/workflows/release.yml. Required defines:
;   AppVersion  - e.g. 4.8.0-ashmit.1
;   SourceDir   - folder whose contents get installed
;   OutputDir   - where the setup exe is written
; Optional:
;   UpdateOnly  - build the small patch installer that drops changed files into an existing install

#ifndef AppVersion
  #error AppVersion is not defined
#endif
#ifndef SourceDir
  #error SourceDir is not defined
#endif
#ifndef OutputDir
  #define OutputDir "."
#endif

#define AppName "Stremio Kai"
#define AppPublisher "AshmitW"
#define AppUrl "https://github.com/AshmitW/Stremio-Kai"
#define AppExe "stremio.exe"

[Setup]
; Distinct from upstream so both can be installed without sharing an uninstaller entry
AppId={{8A5E49B9-8E06-427E-9B07-88C544A9C947}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppUrl}
AppSupportURL={#AppUrl}/issues
AppUpdatesURL={#AppUrl}/releases
; Kai writes into its own folder at runtime, so it must live somewhere user-writable
DefaultDirName={localappdata}\Programs\Stremio-Kai
DefaultGroupName={#AppName}
PrivilegesRequired=lowest
UsePreviousAppDir=yes
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#AppExe}
OutputDir={#OutputDir}
Compression=lzma2/max
SolidCompression=yes
LZMAUseSeparateProcess=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=yes
#ifdef UpdateOnly
OutputBaseFilename=StremioKai_v{#AppVersion}_Update
; Only ask for a folder when no previous install is registered
DisableDirPage=auto
DisableReadyPage=yes
CreateUninstallRegKey=no
UpdateUninstallLogAppName=no
#else
OutputBaseFilename=StremioKai_v{#AppVersion}_Setup
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

#ifndef UpdateOnly
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
#endif

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

#ifndef UpdateOnly
[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon
#endif

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

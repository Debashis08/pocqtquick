; Script generated for Qt Quick Application
; Located at: installer/setup.iss

#define MyAppName "pocqtquick"
#define MyAppPublisher "My Company"
#define MyAppExeName "appCounterApp.exe"

; Default value for local testing. In CI, this is overwritten via command line.
#ifndef MyAppSourceDir
  #define MyAppSourceDir "..\build\release"
#endif

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

#ifndef MyOutputFilename
  #define MyOutputFilename "MyPOC_Setup"
#endif

[Setup]
AppId={{A1B2C3D4-E5F6-7890-1234-56789ABCDEF0}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}

; Output configuration
OutputDir=Output
OutputBaseFilename={#MyOutputFilename}
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible

; UPDATE FLOW SETTINGS
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; The main executable
Source: "{#MyAppSourceDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

; All other files (DLLs, plugins, qml folders) recursively
; Excludes the exe since it is added above, but Inno handles overlap fine usually. 
; Using specific source dir passed from CI.
Source: "{#MyAppSourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
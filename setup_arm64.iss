﻿[Setup]
AppName=RemoteFingerUnlock
AppVersion={#AppVersion}
VersionInfoVersion={#VersionInfoVersion}
AppPublisher=czqu
AppPublisherURL=http://rfu.czqu.net
AppSupportURL=http://rfu.czqu.net
AppUpdatesURL=http://rfu.czqu.net
VersionInfoCopyright=Copyright (C) 2020-2024 Paul Chen.
AppMutex=RemoteFingerUnlockCompilerAppMutex,Global\RemoteFingerUnlockCompilerAppMutex
SetupMutex=RemoteFingerUnlockCompilerSetupMutex,Global\RemoteFingerUnlockCompilerSetupMutex
WizardStyle=modern
Compression=lzma2/max
SolidCompression=yes
DefaultDirName={pf}\RemoteFingerUnlockModule
DefaultGroupName=RemoteFingerUnlock
TimeStampsInUTC=yes
DisableProgramGroupPage=yes
OutputDir=Output
LicenseFile="License.rtf"
AppId={{9C599831-99CF-4185-98C8-E4258849AF0F}
DisableWelcomePage=no
DisableFinishedPage=no

ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
OutputBaseFilename=setup_arm64


[Files]


Source: "start_master.bat"; DestDir: "{app}"                      ;Flags:              uninsrestartdelete
Source: "stop_master.bat"; DestDir: "{app}"                ;Flags:              uninsrestartdelete
Source: "start_slave.bat"; DestDir: "{app}"               ;Flags:              uninsrestartdelete
Source: "stop_slave.bat"; DestDir: "{app}"                 ;Flags:              uninsrestartdelete
Source: "reset_config.bat"; DestDir: "{app}"               ;Flags:              uninsrestartdelete

Source: "core-service-arm64.exe"; DestDir: "{app}"  ; DestName: "core-service.exe"              ;Flags:              uninsrestartdelete
Source: "install-service-arm64.exe"; DestDir: "{app}"  ; DestName: "install-service.exe"                ;Flags:              uninsrestartdelete
Source: "RemoteFingerUnlockModule_ARM64\RemoteFingerUnlockModule.dll"; DestDir: "{app}"                ;Flags:       uninsrestartdelete




[Icons]
Name: "{group}\RemoteFingerUnlockModule\Uninstall RemoteFingerUnlockModule"; Filename: "{uninstallexe}"; WorkingDir: "{app}"



[UninstallDelete]
Type: files; Name: "{app}\RemoteFingerUnlockModule.dll"
Type: files; Name: "{app}\core-service.exe"
Type: files; Name: "{app}\*.dll"
Type: files; Name: "{group}\RemoteFingerUnlockModule\Uninstall RemoteFingerUnlockModule"
Type: files; Name: "{group}\Uninstall RemoteFingerUnlockModule"
Type: files; Name: "{commondesktop}\Uninstall RemoteFingerUnlockModule"


[Registry]

Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "RemoteFingerUnlockCoreService"; ValueData: """{app}\start_slave.bat""  --slave -w {localappdata}\rfu"; Flags: uninsdeletevalue

Root: HKLM; Subkey: "SOFTWARE\RemoteFingerUnlock"; ValueType: string; ValueName: "log_path"; ValueData: "{localappdata}\rfu\log\RemoteFingerUnlockModule.log"      ; Flags: uninsdeletevalue     uninsdeletekeyifempty
Root: HKLM; Subkey: "SOFTWARE\RemoteFingerUnlock"; ValueType: dword; ValueName: "log_level"; ValueData: 2                  ;   Flags: uninsdeletevalue            uninsdeletekeyifempty


Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{{69168A1C-D241-49DA-8077-171E0D35C74F}"; ValueType: string; ValueData: "RemoteFingerUnlockModule"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}\InprocServer32"; ValueType: string; ValueData: "{app}\RemoteFingerUnlockModule.dll"; Flags: uninsdeletevalue     uninsdeletekeyifempty
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}\InprocServer32";  ValueType: string; ValueName: "ThreadingModel" ; ValueData:"Apartment"   ; Flags: uninsdeletevalue      uninsdeletekeyifempty
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}"; ValueType: string; ValueData: "RemoteFingerUnlockModule"; Flags: uninsdeletevalue                     uninsdeletekeyifempty

[Run]
Filename: "cmd.exe"; Parameters: "/C reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v ""远程解锁控制面板"" /f"; Flags: runhidden  nowait

Filename: "{app}\install-service.exe"; Flags:  runhidden waituntilterminated;  Parameters: "-i -w {localappdata}\rfu"    ;  WorkingDir: "{app}";    Check: InstallX64       ;    StatusMsg: "Creating services..."
Filename: "{sys}\sc.exe"; Parameters: "start FadaControlService"; Flags: runhidden  waituntilterminated  ;  StatusMsg: "Starting services..."
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow Port Fada Control Service TCP Inbound"" dir=in action=allow program=""{app}\core-service.exe"" protocol=TCP"; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow Port Fada Control Service UDP Inbound"" dir=in action=allow program=""{app}\core-service.exe"" protocol=UDP"; Flags: runhidden

Filename: "{app}\core-service.exe"; Flags:  runhidden nowait runasoriginaluser;  Parameters: "--slave -w {localappdata}\rfu"    ;  WorkingDir: "{app}";        StatusMsg: "Runing services..."


[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/F /IM rfu_desktop.exe"; WorkingDir: "{app}"; Flags: runhidden waituntilterminated;   StatusMsg: "Stopping services..."
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Allow Port Fada Control Service TCP Inbound"""; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Allow Port Fada Control Service UDP Inbound"""; Flags: runhidden
Filename: "{sys}\sc.exe"; Parameters: "stop FadaControlService";Flags: runhidden   waituntilterminated       ;    StatusMsg: "Stopping  services..."
Filename: "{app}\install-service.exe";     Parameters: "-u"     ;WorkingDir: "{app}"             ;Flags: runhidden   waituntilterminated      ;    StatusMsg: "Deleting  services..."
Filename: "{sys}\taskkill.exe"; Parameters: "/F /IM core-service.exe"; WorkingDir: "{app}"; Flags: runhidden waituntilterminated;  StatusMsg: "Stopping services..."






[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; Check: IsCheck
Name: visitwebsite; Description: Visit our website; Check: IsCheck



[Messages]
WelcomeLabel1=Welcome to the RemoteFingerUnlockModule Setup%nSetup Wizard




[Code]

function InstallX64: Boolean;
begin
  Result := Is64BitInstallMode and (ProcessorArchitecture = paX64);
end;


function InstallARM64: Boolean;
begin
  Result := Is64BitInstallMode and (ProcessorArchitecture = paARM64);
end;

function InstallX86: Boolean;
begin
  Result := IsX86 and (ProcessorArchitecture = paX86);
end;
function IsCheck: Boolean;
begin
  Result := True;
end;
function InitializeSetup(): boolean;
var
  ResultStr: String;
  ResultCode: Integer;
begin
  if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9C599831-99CF-4185-98C8-E4258849AF0F}_is1', 'UninstallString', ResultStr) then
  begin
    ResultStr := RemoveQuotes(ResultStr);


    if MsgBox('A previous version of the software is detected. Do you want to uninstall it before proceeding?', mbConfirmation, MB_YESNO) = IDYES then
    begin

      Exec(ResultStr, '/silent', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;

  Result := True;
end;

function GetModuleHandle(lpModuleName: LongInt): LongInt;
external 'GetModuleHandleA@kernel32.dll stdcall';
function ExtractIcon(hInst: LongInt; lpszExeFileName: String; nIconIndex: LongInt): LongInt;
external 'ExtractIconW@shell32.dll stdcall';
function DrawIconEx(hdc: LongInt; xLeft, yTop: Integer; hIcon: LongInt; cxWidth, cyWidth: Integer; istepIfAniCur: LongInt; hbrFlickerFreeDraw, diFlags: LongInt): LongInt;
external 'DrawIconEx@user32.dll stdcall';
function DestroyIcon(hIcon: LongInt): LongInt;
external 'DestroyIcon@user32.dll stdcall';



[Code]

var
  DeleteConfig: Boolean;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    // Ask the user with a confirmation dialog to delete the configuration files
    if MsgBox('Do you want to delete the program configuration files as well?', mbConfirmation, MB_YESNO) = IDYES then
    begin
      DeleteConfig := True;
    end;
  end;
end;

procedure DeinitializeUninstall();
var
  ConfigPath: String;
begin
  if DeleteConfig then
  begin
    ConfigPath := ExpandConstant('{localappdata}\rfu');
    if DirExists(ConfigPath) then
    begin
      DelTree(ConfigPath, True, True, True);
    end;
  end;
end;

procedure InitializeWizard();
begin
  // Initialize the DeleteConfig flag
  DeleteConfig := False;
end;

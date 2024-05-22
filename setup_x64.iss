[Setup]
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

ArchitecturesAllowed=x64   
ArchitecturesInstallIn64BitMode=x64  
OutputBaseFilename=setup_x64


[Files]


Source: "start_master.bat"; DestDir: "{app}"         ;Check: InstallX64            ;Flags:              uninsrestartdelete
Source: "stop_master.bat"; DestDir: "{app}"      ;Check: InstallX64            ;Flags:              uninsrestartdelete
Source: "start_slave.bat"; DestDir: "{app}"        ;Check: InstallX64            ;Flags:              uninsrestartdelete
Source: "stop_slave.bat"; DestDir: "{app}"        ;Check: InstallX64            ;Flags:              uninsrestartdelete

Source: "core-service-x64.exe"; DestDir: "{app}"  ; DestName: "core-service.exe"     ;Check: InstallX64            ;Flags:              uninsrestartdelete

Source: "RemoteFingerUnlockModule_x64\RemoteFingerUnlockModule.dll"; DestDir: "{app}"   ;Check: InstallX64              ;Flags:       uninsrestartdelete




[Icons]                                                                                                                                 
Name: "{group}\RemoteFingerUnlockModule\Uninstall RemoteFingerUnlockModule"; Filename: "{uninstallexe}"; WorkingDir: "{app}"          ;Check: InstallX64



[UninstallDelete]
Type: files; Name: "{app}\RemoteFingerUnlockModule.dll"             ;Check: InstallX64
Type: files; Name: "{app}\core-service.exe"     ;Check: InstallX64
Type: files; Name: "{app}\*.dll"                                ;Check: InstallX64
Type: files; Name: "{group}\RemoteFingerUnlockModule\Uninstall RemoteFingerUnlockModule"        ;Check: InstallX64
Type: files; Name: "{group}\Uninstall RemoteFingerUnlockModule"                       ;Check: InstallX64
Type: files; Name: "{commondesktop}\Uninstall RemoteFingerUnlockModule"            ;Check: InstallX64


[Registry]

Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "RemoteFingerUnlockCoreService"; ValueData: """{app}\start_slave.bat""  --slave -w {localappdata}\rfu"; Flags: uninsdeletevalue        ;Check: InstallX64

Root: HKLM; Subkey: "SOFTWARE\RemoteFingerUnlock"; ValueType: string; ValueName: "log_path"; ValueData: "{localappdata}\rfu\log\RemoteFingerUnlockModule.log"      ; Flags: uninsdeletevalue     uninsdeletekeyifempty       ;Check: InstallX64
Root: HKLM; Subkey: "SOFTWARE\RemoteFingerUnlock"; ValueType: dword; ValueName: "log_level"; ValueData: 2                  ;   Flags: uninsdeletevalue            uninsdeletekeyifempty     ;Check: InstallX64


Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{{69168A1C-D241-49DA-8077-171E0D35C74F}"; ValueType: string; ValueData: "RemoteFingerUnlockModule"; Flags: uninsdeletevalue        ;Check: InstallX64   
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}\InprocServer32"; ValueType: string; ValueData: "{app}\RemoteFingerUnlockModule.dll"; Flags: uninsdeletevalue     uninsdeletekeyifempty                        ;Check: InstallX64
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}\InprocServer32";  ValueType: string; ValueName: "ThreadingModel" ; ValueData:"Apartment"   ; Flags: uninsdeletevalue      uninsdeletekeyifempty            ;Check: InstallX64
Root: HKCR; Subkey: "CLSID\{{69168A1C-D241-49DA-8077-171E0D35C74F}"; ValueType: string; ValueData: "RemoteFingerUnlockModule"; Flags: uninsdeletevalue                     uninsdeletekeyifempty                        ;Check: InstallX64

[Run]
Filename: "cmd.exe"; Parameters: "/C reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v ""远程解锁控制面板"" /f"; Flags: runhidden  nowait                                                         ;Check: InstallX64

Filename: "{app}\core-service.exe"; Flags:  runhidden waituntilterminated;  Parameters: "-i -w {localappdata}\rfu"    ;  WorkingDir: "{app}";    Check: InstallX64       ;    StatusMsg: "Creating services..."
Filename: "{sys}\sc.exe"; Parameters: "start FadaControlService"; Flags: runhidden  waituntilterminated  ;  StatusMsg: "Starting services..."      ;Check: InstallX64
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow Port Fada Control Service TCP Inbound"" dir=in action=allow protocol=TCP "; Flags: runhidden       ;Check: InstallX64
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Allow Port Fada Control Service UDP Inbound"" dir=in action=allow protocol=UDP "; Flags: runhidden      ;Check: InstallX64             
 
Filename: "{app}\core-service.exe"; Flags:  runhidden nowait runasoriginaluser;  Parameters: "--slave -w {localappdata}\rfu"    ;  WorkingDir: "{app}";    Check: InstallX64       ;    StatusMsg: "Runing services..."


[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/F /IM rfu_desktop.exe"; WorkingDir: "{app}"; Flags: runhidden waituntilterminated; Check: InstallX64; StatusMsg: "Stopping services..."
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Allow Port Fada Control Service TCP Inbound"""; Flags: runhidden         ;Check: InstallX64
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Allow Port Fada Control Service UDP Inbound"""; Flags: runhidden          ;Check: InstallX64
Filename: "{sys}\sc.exe"; Parameters: "stop FadaControlService";Flags: runhidden   waituntilterminated     ;Check: InstallX64   ;    StatusMsg: "Stopping  services..."   
Filename: "{app}\core-service.exe";     Parameters: "-u"     ;WorkingDir: "{app}"             ;Flags: runhidden   waituntilterminated     ;Check: InstallX64 ;    StatusMsg: "Deleting  services..."
Filename: "{sys}\taskkill.exe"; Parameters: "/F /IM core-service.exe"; WorkingDir: "{app}"; Flags: runhidden waituntilterminated;  StatusMsg: "Stopping services..."    ;Check: InstallX64

 




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


procedure CurStepChanged(CurStep: TSetupStep);
var
  ErrorCode: Integer;
begin
  if CurStep=ssPostInstall then
    if not WizardSilent and IsTaskSelected('visitwebsite') then
    begin
      ShellExec('open', 'http://rfu.czqu.net', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
    end;
end;





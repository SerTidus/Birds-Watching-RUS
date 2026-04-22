[Setup]
AppId={{8E4B17A7-5A0F-4B6D-9A88-BIRDSWATCHRUS}}
AppName=Birds Watching Русификатор
AppVersion=1.0
DefaultDirName={autopf}\Birds Watching
DefaultGroupName=Birds Watching Русификатор
OutputDir=.
OutputBaseFilename=BirdsWatching_RUS_Setup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\Birds Watching.exe

[Files]
Source: "Birds Watching_patched.exe"; DestDir: "{app}"; DestName: "Birds Watching.exe"; Flags: ignoreversion; BeforeInstall: BackupOriginalExe
Source: "README_RUS.txt"; DestDir: "{app}"; Flags: ignoreversion

[Code]
procedure BackupOriginalExe();
var
  GameExe, BackupExe: string;
begin
  GameExe := ExpandConstant('{app}\Birds Watching.exe');
  BackupExe := ExpandConstant('{app}\Birds Watching.exe.bak');

  if not FileExists(GameExe) then
  begin
    MsgBox('В выбранной папке не найден файл Birds Watching.exe', mbCriticalError, MB_OK);
    RaiseException('Файл игры не найден.');
  end;

  if not FileExists(BackupExe) then
  begin
    if not FileCopy(GameExe, BackupExe, False) then
    begin
      MsgBox('Не удалось создать резервную копию оригинального exe.', mbCriticalError, MB_OK);
      RaiseException('Не удалось создать backup.');
    end;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  GameExe: string;
begin
  Result := True;

  if CurPageID = wpSelectDir then
  begin
    GameExe := AddBackslash(WizardDirValue) + 'Birds Watching.exe';
    if not FileExists(GameExe) then
    begin
      MsgBox('В этой папке не найден Birds Watching.exe. Укажите папку, где установлена игра.', mbCriticalError, MB_OK);
      Result := False;
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  GameExe, BackupExe: string;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    GameExe := ExpandConstant('{app}\Birds Watching.exe');
    BackupExe := ExpandConstant('{app}\Birds Watching.exe.bak');

    if FileExists(BackupExe) then
    begin
      if FileExists(GameExe) then
        DeleteFile(GameExe);
      RenameFile(BackupExe, GameExe);
    end;
  end;
end;
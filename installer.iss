[Setup]
AppId={{8E4B17A7-5A0F-4B6D-9A88-BIRDSWATCHRUS}}
AppName=Birds Watching Русификатор
AppVersion=1.0
AppPublisher=Серго (Tidus)

DefaultDirName={autopf}
AppendDefaultDirName=no
UsePreviousAppDir=no

DefaultGroupName=Birds Watching Русификатор
OutputDir=.
OutputBaseFilename=BirdsWatching_RUS_Setup_v2

SetupIconFile=installer_icon.ico

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
    MsgBox('В выбранной папке не найден файл Birds Watching.exe.' + #13#10 +
           'Укажите именно папку, где установлена игра Birds Watching.' + #13#10 + #13#10 +
           'Например:' + #13#10 +
           '...\SteamLibrary\steamapps\common\Birds Watching',
           mbCriticalError, MB_OK);
    RaiseException('Файл игры не найден.');
  end;

  if not FileExists(BackupExe) then
  begin
    if not FileCopy(GameExe, BackupExe, False) then
    begin
      MsgBox('Не удалось создать резервную копию оригинального файла Birds Watching.exe.',
             mbCriticalError, MB_OK);
      RaiseException('Не удалось создать резервную копию.');
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
      MsgBox('В этой папке не найден файл Birds Watching.exe.' + #13#10 +
             'Пожалуйста, укажите именно папку, где установлена игра Birds Watching.' + #13#10 + #13#10 +
             'Например:' + #13#10 +
             '...\SteamLibrary\steamapps\common\Birds Watching',
             mbCriticalError, MB_OK);
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

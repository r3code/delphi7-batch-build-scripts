program MyApp;

{$R '..\resources\versioninfo\MyAppVersionInfo.res' '..\resources\versioninfo\MyAppVersionInfo.rc'}

uses
{$IFDEF Debug }
  FastMM4,
{$ENDIF}
{$IFDEF madExcept }
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
{$ENDIF}
  Forms,
  uMyApp in '..\source\uMyApp.pas' {frmMain},
  uLogger in '..\source\logger\uLogger.pas',
  uCalc in '..\source\uCalc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

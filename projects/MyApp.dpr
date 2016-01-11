program MyApp;

{$R '..\resources\versioninfo\MyAppVersionInfo.res' '..\resources\versioninfo\MyAppVersionInfo.rc'}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
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

unit uMyApp;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  uLogger;

type
  TfrmMain = class(TForm)
    edtA: TEdit;
    edtB: TEdit;
    edtSum: TEdit;
    btnSum: TButton;
    lblA: TLabel;
    lblB: TLabel;
    lblTotal: TLabel;
    mmoLog: TMemo;
    lblLog: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSumClick(Sender: TObject);
  private
    FLogger: TLogger;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uCalc;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  mmoLog.Lines.Clear;
  FLogger := TLogger.Create(mmoLog.Lines);
  FLogger.LogMsg('App started');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLogger);
end;

procedure TfrmMain.btnSumClick(Sender: TObject);
var
  Calc: TCalc;
begin
  Calc := TCalc.Create(StrToInt(edtA.Text), StrToInt(edtB.Text));
  FLogger.LogMsg('DIV A=' + edtA.Text + ' by B=' + edtB.Text);
  try
    edtSum.Text := FloatToStr(Calc.GetADevidedB);
    FLogger.LogMsg('Result is ' + edtSum.Text);
  finally
    FreeAndNil(Calc);
  end;
end;

end.


unit TestCalc;

interface

uses
  Windows,
  SysUtils,
  Classes,
  TestFramework,
  TestExtensions,
  uCalc;

type
  TTestCalc = class(TTestCase)
  private
    procedure CallZeroDevide;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure DevidedOK;
    procedure DeviceFailsWithZeroDivider;
  end;

implementation

procedure TTestCalc.CallZeroDevide;
const
  A = 6;
  B = 0;
begin
  with TCalc.Create(A, B) do
  try
    CheckEquals(3, GetADevidedB);
  finally
    Free;
  end;
end;

procedure TTestCalc.DeviceFailsWithZeroDivider;
begin
  CheckException(CallZeroDevide, EZeroDivide);
end;

procedure TTestCalc.DevidedOK;
const
  A = 6;
  B = 2;
begin
  with TCalc.Create(A, B) do
  try
    CheckEquals(3, GetADevidedB);
  finally
    Free;
  end;
end;

procedure TTestCalc.Setup;
begin
end;

procedure TTestCalc.TearDown;
begin

end;


initialization
  TestFramework.RegisterTest(TTestCalc.Suite);

end.


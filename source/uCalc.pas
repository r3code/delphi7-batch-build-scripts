unit uCalc;

interface

type
  TCalc = class(TObject)
  private
    FA: integer;
    FB: Integer;
  public
    constructor Create(const A, B: Integer); 
    destructor Destroy; override;
    function GetADevidedB: Double;
  end;    

implementation

{ TCalc }

constructor TCalc.Create(const A, B: Integer);
begin
  FA := A;
  FB := B;
end;

destructor TCalc.Destroy;
begin
  //
end;

function TCalc.GetADevidedB: Double;
begin
  Result := FA / FB;
end;

end.

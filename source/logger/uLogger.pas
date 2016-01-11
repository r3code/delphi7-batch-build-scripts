unit uLogger;

interface

uses
  Classes;

type
  TLogger = class(TObject)
  private
    FLogStore: TStrings;
  public
    constructor Create(ALogStore: TStrings);
    destructor Destroy; override;
    procedure LogMsg(const AMsg: string);
  end;

implementation

{ TLogger }

constructor TLogger.Create(ALogStore: TStrings);
begin
  FLogStore := ALogStore;
end;

destructor TLogger.Destroy;
begin

  inherited;
end;

procedure TLogger.LogMsg(const AMsg: string);
begin
  FLogStore.Add(AMsg);
end;

end.

program ds;

uses
  Forms,
  Windows,
  ds1 in 'ds1.pas' {Form1};

function Check: boolean;
begin
  HM:= OpenMutex(MUTEX_ALL_ACCESS, false, 'ds');
  Result := (HM <> 0);
  if HM = 0 then HM := CreateMutex(nil, false, 'ds');
end;

{$R *.res}

begin
  if Check then
  begin
//  ShowMessage('Запуск более одной копии программы запрещен!');
  Exit;
  end;
  Application.Initialize;
  Application.Title := 'Не спать';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

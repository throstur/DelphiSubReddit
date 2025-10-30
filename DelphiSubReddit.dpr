program DelphiSubReddit;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uFetchReddit in 'uFetchReddit.pas',
  uSubReddit in 'uSubReddit.pas',
  uSubRedditPost in 'uSubRedditPost.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

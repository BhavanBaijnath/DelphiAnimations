program DelphiAnimationsDemo_p;

uses
  Forms,
  DelphiAnimationsDemo_u in 'DelphiAnimationsDemo_u.pas' {frmDelphiAnimations},
  DelphiAnimations in 'DelphiAnimations.pas',
  DelphiFixes in 'DelphiFixes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDelphiAnimations, frmDelphiAnimations);
  Application.Run;
end.

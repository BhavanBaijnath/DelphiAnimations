unit DelphiAnimationsDemo_u;

{ Please note, it is reccomended to enable DooubleBuffered and disable FullRepaint for each panel to reduce flickering }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DelphiAnimations;

type
  TfrmDelphiAnimations = class(TForm)
    Panel1: TPanel;
    DelphiAnimations: TTimer;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    procedure Panel1MouseEnter(Sender: TObject);
    procedure DelphiAnimationsTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure Panel2MouseEnter(Sender: TObject);
    procedure Panel2MouseLeave(Sender: TObject);
    procedure Panel3MouseEnter(Sender: TObject);
    procedure Panel3MouseLeave(Sender: TObject);
    procedure Panel4MouseEnter(Sender: TObject);
    procedure Panel4MouseLeave(Sender: TObject);
    procedure Panel5MouseEnter(Sender: TObject);
    procedure Panel5MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDelphiAnimations: TfrmDelphiAnimations;

implementation

{$R *.dfm}

procedure TfrmDelphiAnimations.DelphiAnimationsTimer(Sender: TObject);
begin

  AnimationTimer;

end;

procedure TfrmDelphiAnimations.FormCreate(Sender: TObject);
begin

  DelphiAnimations.Interval := 1;

end;

procedure TfrmDelphiAnimations.Panel1MouseEnter(Sender: TObject);
begin
  AddAnimation(Panel1, 'Top', -10, 10); // Moves the panel 10 pixels up over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel1MouseLeave(Sender: TObject);
begin
  AddAnimation(Panel1, 'Top', 10, 10); // Moves the panel 10 pixels down over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel2MouseEnter(Sender: TObject);
begin
  AddAnimation(Panel2, 'Left', -10, 10); // Moves the panel 10 pixels left over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel2MouseLeave(Sender: TObject);
begin
  AddAnimation(Panel2, 'Left', 10, 10); // Moves the panel 10 pixels right over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel3MouseEnter(Sender: TObject);
begin
  AddAnimation(Panel3, 'Left', 10, 10); // Moves the panel 10 pixels right over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel3MouseLeave(Sender: TObject);
begin
  AddAnimation(Panel3, 'Left', -10, 10); // Moves the panel 10 pixels left over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel4MouseEnter(Sender: TObject);
begin
  AddAnimation(Panel4, 'Top', 10, 10); // Moves the panel 10 pixels down over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel4MouseLeave(Sender: TObject);
begin
  AddAnimation(Panel4, 'Top', -10, 10); // Moves the panel 10 pixels up over 10 milliseconds
end;

procedure TfrmDelphiAnimations.Panel5MouseEnter(Sender: TObject);

const
  Movement = 10;

begin

  // Makes the button appear to expand by countering the change in Width and Height by moving it up and left
  AddAnimation(Panel5, 'Top', -Movement, 10);
  AddAnimation(Panel5, 'Left', -Movement, 10);
  AddAnimation(Panel5, 'Width', 2 * Movement, 10);
  AddAnimation(Panel5, 'Height', 2 * Movement, 10);

end;

procedure TfrmDelphiAnimations.Panel5MouseLeave(Sender: TObject);

const
  Movement = -10;

begin

  // Makes the button appear to shrink by countering the change in Width and Height by moving it down and right
  AddAnimation(Panel5, 'Top', -Movement, 5);
  AddAnimation(Panel5, 'Left', -Movement, 5);
  AddAnimation(Panel5, 'Width', 2 * Movement, 5);
  AddAnimation(Panel5, 'Height', 2 * Movement, 5);

end;

end.

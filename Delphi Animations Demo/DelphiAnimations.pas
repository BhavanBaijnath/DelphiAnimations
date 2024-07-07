unit DelphiAnimations;

{ Version: 1.0.0 - 4 July 2024
  Updates on GitHub: https://github.com/BhavanBaijnath/DelphiAnimations

  Created by Bhavan Baijnath
  
  DelphiAnimations is a Delphi unit that aims to make creating UI animations in Delphi very simple

  Setup:
  1. Add DelphiAnimations to your project and under 'Uses' in the form
  2. Create a TTimer component on your form and set the Interval property to 1
  3. Assign the AnimationTimer to the OnTimer event of your Timer

  Notes:
  - If you animations seem to be buggy and stopping at random points, increase the 'MaxAnimations' value below
  - This is a little buggy sometimes so try to work with even numbers and when adding an animation,
  make sure the 'Time' value is less than the 'Movement' value and that 'Movement' is a multiple of 'Time'

  Enjoy! }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Math, pngimage, jpeg, DelphiFixes;

procedure AddAnimation(var pnlObject: TPanel; sProperty: String;
  iMovement, iTime: Integer);
procedure DeleteAnimation(iIndex: Integer);
procedure AnimationTimer;

const
  MaxAnimations = 100;

var
  arrAnimationObject: Array [1 .. MaxAnimations] of TPanel;
  // Stores the panel that will be animated 

  arrAnimationProperty: Array [1 .. MaxAnimations] of string;
  // Top, Left, Width or Height 

  arrAnimationChange: Array [1 .. MaxAnimations] of Integer;
  // Stores the movement of the panel everytime the timer runs 

  arrAnimationCycles: Array [1 .. MaxAnimations] of Integer;
  // Stores the number of times the movement will occur for, when it reaches 0 the animation is deleted 

implementation

procedure AddAnimation(var pnlObject: TPanel; sProperty: String;
  iMovement, iTime: Integer);

var
  i: Integer;

begin

  for i := 1 to MaxAnimations do
    if arrAnimationObject[i] = nil then
    begin
      arrAnimationObject[i] := pnlObject;
      arrAnimationProperty[i] := sProperty;
      arrAnimationChange[i] := iMovement div iTime;
      arrAnimationCycles[i] := iTime;

      Exit;
    end;

end;

procedure DeleteAnimation(iIndex: Integer);
begin

  // Sets the values of the animation to be essentially empty which 'deletes' it 
  arrAnimationObject[iIndex] := nil;
  arrAnimationProperty[iIndex] := '';
  arrAnimationChange[iIndex] := 0;
  arrAnimationCycles[iIndex] := 0;

end;

procedure AnimationTimer;

var
  i, iChange: Integer;
  sProperty: String;
  pnlPanel: TPanel;

begin

  for i := 1 to MaxAnimations do
  begin
    Application.ProcessMessages;

    if arrAnimationObject[i] <> nil then
    begin

      sProperty := arrAnimationProperty[i];
      pnlPanel := arrAnimationObject[i];
      iChange := arrAnimationChange[i];

      if sProperty = 'Left' then
        arrAnimationObject[i].Left := arrAnimationObject[i].Left + iChange
      else if sProperty = 'Top' then
        arrAnimationObject[i].Top := arrAnimationObject[i].Top + iChange
      else if sProperty = 'Width' then
        arrAnimationObject[i].Width := arrAnimationObject[i].Width + iChange
      else if sProperty = 'Height' then
        arrAnimationObject[i].Height := arrAnimationObject[i]
          .Height + iChange; ;

      Dec(arrAnimationCycles[i]);

      if arrAnimationCycles[i] = 0 then
        DeleteAnimation(i);

    end;
  end;

end;

end.

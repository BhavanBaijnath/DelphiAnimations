object frmDelphiAnimations: TfrmDelphiAnimations
  Left = 0
  Top = 0
  Caption = 'frmDelphiAnimations'
  ClientHeight = 265
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 185
    Height = 41
    Caption = 'Moves Up On Hover'
    DoubleBuffered = False
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnMouseEnter = Panel1MouseEnter
    OnMouseLeave = Panel1MouseLeave
  end
  object Panel2: TPanel
    Left = 16
    Top = 80
    Width = 185
    Height = 41
    Caption = 'Moves Left On Hover'
    DoubleBuffered = False
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 1
    OnMouseEnter = Panel2MouseEnter
    OnMouseLeave = Panel2MouseLeave
  end
  object Panel3: TPanel
    Left = 16
    Top = 144
    Width = 185
    Height = 41
    Caption = 'Moves Right On Hover'
    DoubleBuffered = False
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 2
    OnMouseEnter = Panel3MouseEnter
    OnMouseLeave = Panel3MouseLeave
  end
  object Panel4: TPanel
    Left = 16
    Top = 208
    Width = 185
    Height = 41
    Caption = 'Moves Down On Hover'
    DoubleBuffered = False
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 3
    OnMouseEnter = Panel4MouseEnter
    OnMouseLeave = Panel4MouseLeave
  end
  object Panel5: TPanel
    Left = 224
    Top = 208
    Width = 185
    Height = 41
    Caption = 'Panel5'
    DoubleBuffered = False
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 4
    OnMouseEnter = Panel5MouseEnter
    OnMouseLeave = Panel5MouseLeave
  end
  object DelphiAnimations: TTimer
    OnTimer = DelphiAnimationsTimer
    Left = 528
    Top = 8
  end
end

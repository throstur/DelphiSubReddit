object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Reddit Reader'
  ClientHeight = 680
  ClientWidth = 923
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button_Load: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Load Reddit'
    TabOrder = 0
    OnClick = Button_LoadClick
  end
  object TreeView_Posts: TTreeView
    Left = 32
    Top = 48
    Width = 841
    Height = 585
    Indent = 19
    TabOrder = 1
  end
end

unit DelphiFixes;

// Rename all variables correctly

{ Version: 1.0.5 - 28 June 2024
  Updates on GitHub: https://github.com/BhavanBaijnath/DelphiFixes

  Created by Bhavan Baijnath, a Gr11 student who finds Delphi's incompetency and complexity incredible frustrating.

  ToStr(), ToInt(), ToFloat():
  - These custom functions are designed to help speed up typecasting
  - Any type of variable can be inputted into these functions and (hopefully) the correct type will be outputted

  RemoveCharacter() & RemoveManyCharacters():
  - Procedures to remove characters
  - RemoveCharacter() inputs a single character and the string to be processed, aswell as a boolean for case sensitive
  - RemoveManyCharacters() is the same as RemoveCharacter() except a string of the characters to remove is inputted rather than a character

  LocalFilePath():
  - A function to output the complete file path for the file inputted (assuming the file is in the same folder or in a sub folder found in the projects folder)
  eg.
  Your project is stored in 'C:\Delphi Projects\':
  LocalFilePath('image.png') will return 'C:\Delphi Projects\image.png'
  LocalFilePath('Images\image.png') will return 'C:\Delphi Projects\Images\image.png'

  ConnectDatabase():
  - A procedure to connect a ADOConnection to a .mdb file at the specified path (if only part of the path is given it assumes it is in the same directory as the project or in a subfolder in that directory)

  ConnectTable():
  - A procedure to connect a ADOTable to the specified ADOConnection

  EditRecord() & InsertRecord():
  - Two very similar procedures to edit/insert records in the specified table
  - The input of the fields are specified using an array
  - Inputs for ALL the fields should be given in their original data type
  - To avoid errors when processing, if a field is an autonumber no changes will be made
  eg.
  InsertRecord(tblUsers, ['', 'Bhavan', 'P@$$w0rd', '3 October 2007']) - The fields are UserID | Username | Password | DateOfBirth
  Will output:
  UserID  | Username  | Password  | DateOfBirth
  1       | Bhavan    | P@$$w0rd  | 03/10/2007

  DeleteRecord():
  - A procedure based on Delphi's TADOTable.Delete procedure
  - Also checks if the specified table is not empty to avoid errors

  CloseTables() & OpenTables():
  - Procedures that close all tables inputted through an array

  Notable things:
  - If a float is inputted into ToInt(), it will be correctly rounded off (Unlike the default Round() function)
  - ToFloat() will work with both commas and decimals and (hopefully) won't cause any errors
  (The other weird Windows formatting for decimals probably won't work though)
  - For RemoveManyCharacters() the list of characters must be inputted as a string
  - DeleteRecord(), InsertRecord() and EditRecord() check if the table is already opened, if not the table will be opened at the begining and closed at the end

  Enjoy
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Math, ADODB, DB, ExtCtrls, StdCtrls, ComCtrls;

function ToStr(input: Variant): String;
function ToInt(input: Variant): Integer;
function ToFloat(input: Variant): Real;
procedure RemoveCharacter(cChar: char; var sString: String;
  bCaseSensitive: Boolean);
procedure RemoveManyCharacters(sChars: String; var sString: String;
  bCaseSensitive: Boolean);
function FilePath(sLocalPath: String): String;
procedure ConnectDatabase(var conDatabase: TADOConnection;
  sDatabaseLocation: String; owner: TObject);
procedure RefreshConnection(var conDatabase: TADOConnection);
procedure ConnectTable(var tblTable: TADOTable; sTableName: String;
  conDatabase: TADOConnection);
procedure EditRecord(var tblTable: TADOTable; arrInput: Array of Variant);
procedure InsertRecord(var tblTable: TADOTable; arrInput: Array of Variant);
procedure DeleteRecord(var tblTable: TADOTable);
procedure OpenTables(arrTables: Array of TADOTable);
procedure CloseTables(arrTables: Array of TADOTable);
function FindRecord(tblTable: TADOTable; sFieldName, sSearch: String): Boolean;
function CreatePanel(iWidth: Integer; iHeight: Integer; iLeft: Integer;
  iTop: Integer; sName: String; owner: TComponent): TPanel;
function CreateEdit(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TEdit;
function CreateLabel(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TLabel;
function CreateButton(iWidth, iHeight, iLeft, iTop: Integer; owner: TComponent;
  OnClick: TNotifyEvent): TButton;
function CreateRichEdit(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TRichEdit;
function CreateImage(iWidth, iHeight, iLeft, iTop: Integer;
  cmpOwner: TComponent): TImage;
function IntPos(iFind: Integer; arrSource: Array of Integer): Integer;

implementation

function ToFloat(input: Variant): Real;

var
  i, iDecimalPos: Integer;
  cFractionSeparator: char;
  sInput, sInputTemp: String;
  iFraction, iInteger, iDigitsAfterDecimal: Integer;

begin

  if VarType(input) in [varSingle, varDouble, varCurrency, varSmallint,
    varInteger, varInt64, varByte, varShortInt] then
    Result := input
  else if (VarType(input) = varString) or (VarType(input) = varUString) then
  begin

    sInputTemp := input;
    sInput := '';

    for i := 1 to Length(sInputTemp) do
      // Removes any characters that could cause errors
      if ((sInputTemp[i] in ['0' .. '9']) or (sInputTemp[i] in [',', '.'])) then
      begin
        sInput := sInput + sInputTemp[i];
      end;

    if not((Pos(',', sInputTemp) = 0) and (Pos('.', sInputTemp) = 0)) then
    begin

      cFractionSeparator := '-';
      iDecimalPos := -1;

      iFraction := 0;
      iInteger := 0;

      // Finding the last decimal/comma which could be the separator
      for i := 1 to Length(sInput) do
        if sInput[i] in [',', '.'] then
        begin
          cFractionSeparator := sInput[i];
          iDecimalPos := i;
        end;

      iDigitsAfterDecimal := Length(sInput) - iDecimalPos;

      iFraction := ToInt(Copy(sInput, iDecimalPos + 1, iDigitsAfterDecimal));

      iInteger := ToInt(Copy(sInput, 1, iDecimalPos - 1));

      Result := iInteger + iFraction / Power(10, iDigitsAfterDecimal);
    end
    else
    begin

      sInput := input;
      RemoveCharacter(' ', sInput, False);

      Result := StrToInt(sInput)

    end;

  end;

end;

function ToInt(input: Variant): Integer;
begin

  if (VarType(input) = varString) or (VarType(input) = varUString) then
    Result := ToInt(ToFloat(input))
  else if VarType(input) in [varSmallint, varInteger, varInt64, varByte,
    varShortInt] then
    Result := input
  else if VarType(input) in [varSingle, varDouble, varCurrency] then
    if Frac(input) >= 0.5 then
      Result := Trunc(input) + 1
    else
      Result := Trunc(input);

end;

function ToStr(input: Variant): String;
begin

  if (VarType(input) = varString) or (VarType(input) = varUString) then
    Result := input
  else if VarType(input) in [varSmallint, varInteger, varInt64, varByte,
    varShortInt] then
    Result := IntToStr(input)
  else if VarType(input) in [varSingle, varDouble, varCurrency] then
    Result := FloatToStr(input)
  else if VarType(input) = varBoolean then
    if input = True then
      Result := 'True'
    else
      Result := 'False';

end;

procedure RemoveCharacter(cChar: char; var sString: String;
  bCaseSensitive: Boolean);

var
  i: Integer;
  sResult, sStringCase: String;
begin

  if not bCaseSensitive then
  begin
    cChar := UpCase(cChar);
    sStringCase := UpperCase(sString);
  end
  else
    sStringCase := sString;

  sResult := '';

  for i := 1 to Length(sString) do
    if sStringCase[i] <> cChar then
      sResult := sResult + sString[i];

  sString := sResult;

end;

procedure RemoveManyCharacters(sChars: String; var sString: String;
  bCaseSensitive: Boolean);

var
  i: Integer;
  sResult: String;
begin

  sResult := sString;

  { for i := 1 to Length(sString) do
    if sString[i] in arrChars then
    sResult := sResult + sString[i]; }

  for i := 1 to Length(sChars) do
  begin
    RemoveCharacter(sChars[i], sResult, bCaseSensitive)
  end;

  sString := sResult;

end;

function FilePath(sLocalPath: String): String;

var
  i: Integer;

begin

  sLocalPath := Trim(sLocalPath);

  if sLocalPath[1] in ['\', '/'] then
    Delete(sLocalPath, 1, 1);

  for i := 1 to Length(sLocalPath) do
    if sLocalPath[i] = '/' then
      sLocalPath[i] := '\';

  Result := ExtractFilePath(Application.ExeName) + sLocalPath;

end;

procedure ConnectDatabase(var conDatabase: TADOConnection;
  sDatabaseLocation: String; owner: TObject);
begin

  if not(Pos(':', sDatabaseLocation) > 0) then
    sDatabaseLocation := FilePath(sDatabaseLocation);

  // Creating connection
  conDatabase := TADOConnection.Create(nil);

  // Setting up connection
  conDatabase.ConnectionString :=
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + sDatabaseLocation +
    ';Mode=ReadWrite;Persist Security Info=False';
  conDatabase.LoginPrompt := False;
  conDatabase.Open;

end;

procedure RefreshConnection(var conDatabase: TADOConnection);
begin

  conDatabase.Close;
  conDatabase.Open;

end;

procedure ConnectTable(var tblTable: TADOTable; sTableName: String;
  conDatabase: TADOConnection);
begin

  tblTable := TADOTable.Create(conDatabase.owner);
  tblTable.Connection := conDatabase;
  tblTable.TableName := sTableName;

end;

procedure EditRecord(var tblTable: TADOTable; arrInput: Array of Variant);

var
  i: Integer;
  bOpen: Boolean;
begin

  bOpen := tblTable.Active;

  if not bOpen then
    tblTable.Open;

  tblTable.Edit;

  // Looping through each field in the table and finding the fileds name
  for i := 0 to tblTable.FieldCount - 1 do
  begin
    // if the datatype is a date it won't convert it to a string
    if tblTable.Fields[i].DataType in [ftDate, ftDateTime] then
      tblTable[tblTable.Fields[i].DisplayName] := arrInput[i]
      // if the field is not a autonumber it will convert the value to a string and assign
    else if tblTable.Fields[i].DataType <> ftAutoInc then
      tblTable[tblTable.Fields[i].DisplayName] := arrInput[i];
  end;

  tblTable.Post;

  if not bOpen then
    tblTable.Close;

end;

procedure InsertRecord(var tblTable: TADOTable; arrInput: Array of Variant);

var
  i: Integer;
  bOpen: Boolean;
begin

  bOpen := tblTable.Active;

  if not bOpen then
    tblTable.Open;

  tblTable.Insert;

  // Looping through each field in the table and finding the fileds name
  for i := 0 to tblTable.FieldCount - 1 do
  begin
    // if the datatype is a date it won't convert it to a string
    if tblTable.Fields[i].DataType in [ftDate, ftDateTime] then
      tblTable[tblTable.Fields[i].DisplayName] := arrInput[i]
      // if the field is not a autonumber it will convert the value to a string and assign
    else if tblTable.Fields[i].DataType <> ftAutoInc then
      tblTable[tblTable.Fields[i].DisplayName] := ToStr(arrInput[i]);
  end;

  tblTable.Post;

  if not bOpen then
    tblTable.Close;

end;

procedure DeleteRecord(var tblTable: TADOTable);

var
  bOpen: Boolean;

begin

  bOpen := tblTable.Active;

  if not bOpen then
    tblTable.Open;

  if tblTable.RecordCount > 0 then
    tblTable.Delete;

  if not bOpen then
    tblTable.Close;

end;

procedure OpenTables(arrTables: Array of TADOTable);

var
  i: Integer;
begin

  for i := 0 to Length(arrTables) - 1 do
    if not arrTables[i].Active then
      arrTables[i].Open;

end;

procedure CloseTables(arrTables: Array of TADOTable);

var
  i: Integer;
begin

  for i := 0 to Length(arrTables) - 1 do
    if arrTables[i].Active then
      arrTables[i].Close;

end;

function FindRecord(tblTable: TADOTable; sFieldName, sSearch: String): Boolean;

var
  bOpen: Boolean;

begin

  bOpen := tblTable.Active;

  if not bOpen then
    tblTable.Open;

  tblTable.First;

  while not tblTable.Eof do
  begin
    if tblTable[sFieldName] = sSearch then
    begin
      Result := True;
      Exit;
    end
    else
      tblTable.Next;
  end;

  Result := False;

  if not bOpen then
    tblTable.Close;

end;

function CreatePanel(iWidth: Integer; iHeight: Integer; iLeft: Integer;
  iTop: Integer; sName: String; owner: TComponent): TPanel;

var
  panel: TPanel;

begin

  panel := TPanel.Create(owner);
  panel.SetParentComponent(owner);

  panel.SetBounds(iLeft, iTop, iWidth, iHeight);

  if sName <> null then
    panel.Name := sName;

  panel.ParentBackground := False;
  panel.DoubleBuffered := True;
  panel.FullRepaint := False;

  Result := panel;

end;

function CreateEdit(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TEdit;

var
  Edit: TEdit;

begin

  Edit := TEdit.Create(owner);
  Edit.SetParentComponent(owner);

  if iWidth <> -1 then
    Edit.Width := iWidth;

  if iHeight <> -1 then
    Edit.Height := iHeight;

  Edit.Left := iLeft;
  Edit.Top := iTop;

  Result := Edit;

end;

function CreateLabel(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TLabel;
var
  lblLabel: TLabel;
begin

  lblLabel := TLabel.Create(owner);
  lblLabel.SetParentComponent(owner);

  lblLabel.AutoSize := False;

  lblLabel.SetBounds(iLeft, iTop, iWidth, iHeight);

  Result := lblLabel;
end;

function CreateButton(iWidth, iHeight, iLeft, iTop: Integer; owner: TComponent;
  OnClick: TNotifyEvent): TButton;

var
  btnButton: TButton;

begin

  btnButton := TButton.Create(owner);
  btnButton.SetParentComponent(owner);

  if iWidth <> -1 then
    btnButton.Width := iWidth;

  if iHeight <> -1 then
    btnButton.Height := iHeight;

  btnButton.Top := iTop;
  btnButton.Left := iLeft;

  btnButton.OnClick := OnClick;

  Result := btnButton;

end;

function CreateRichEdit(iWidth, iHeight, iLeft, iTop: Integer;
  owner: TComponent): TRichEdit;

var
  RichEdit: TRichEdit;

begin

  RichEdit := TRichEdit.Create(owner);
  RichEdit.SetParentComponent(owner);

  if iWidth <> -1 then
    RichEdit.Width := iWidth;

  if iHeight <> -1 then
    RichEdit.Height := iHeight;

  RichEdit.Left := iLeft;
  RichEdit.Top := iTop;

  Result := RichEdit;

end;

function CreateImage(iWidth, iHeight, iLeft, iTop: Integer;
  cmpOwner: TComponent): TImage;

var
  imgImage: TImage;

begin

  imgImage := TImage.Create(cmpOwner);
  imgImage.SetParentComponent(cmpOwner);
  imgImage.SetBounds(iLeft, iTop, iWidth, iHeight);
  imgImage.Stretch := True;
  imgImage.Proportional := True;
  imgImage.Center := True;
  imgImage.IncrementalDisplay := True;

  Result := imgImage;

end;

function IntPos(iFind: Integer; arrSource: Array of Integer): Integer;

var
  i: Integer;

begin

  Result := -1;
  i := 0;

  while i <= Length(arrSource) do
  begin
    Inc(i);

    if arrSource[i] = iFind then
    begin
      Result := i;
      Exit;
    end;

  end;

end;

end.

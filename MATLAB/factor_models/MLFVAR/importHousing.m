function pplongS3 = importHousing(workbookFile, sheetName, startRow, endRow)
%IMPORTFILE1 Import data from a spreadsheet
%  PPLONGS3 = IMPORTFILE1(FILE) reads data from the first worksheet in
%  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
%  a table.
%
%  PPLONGS3 = IMPORTFILE1(FILE, SHEET) reads from the specified
%  worksheet.
%
%  PPLONGS3 = IMPORTFILE1(FILE, SHEET, STARTROW, ENDROW) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  STARTROW and ENDROW as a pair of scalars or vectors of matching size
%  for dis-contiguous row intervals.
%
%  Example:
%  pplongS3 = importfile1("/home/precision/GoogleDrive/Datasets/pp_long.xlsx", "Sheet4", 2, 111);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 03-Apr-2019 18:22:29

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 111;
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 23);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "B" + startRow(1) + ":X" + endRow(1);

% Specify column names and types
opts.VariableNames = ["Australia", "Belgium", "Canada", "Switzerland", "Germany", "Denmark", "Spain", "Finland", "France", "UnitedKingdom", "HongKongSAR", "Ireland", "Italy", "Japan", "Korea", "Malaysia", "Netherlands", "Norway", "NewZealand", "Sweden", "Thailand", "UnitedStates", "SouthAfrica"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data
pplongS3 = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:length(startRow)
    opts.DataRange = "B" + startRow(idx) + ":X" + endRow(idx);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    pplongS3 = [pplongS3; tb]; %#ok<AGROW>
end

end
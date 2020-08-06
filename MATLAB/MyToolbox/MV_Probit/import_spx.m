function spx = importfile( dataLines)
%IMPORTFILE Import data from a text file
%  SPX = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  SPX = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  spx = importfile("/home/precision/GoogleDrive/Datasets/ExcessReturns/spx.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 04-Aug-2020 21:15:30

%% Input handling
filename = '/home/precision/GoogleDrive/Datasets/ExcessReturns/spx.csv';
% If dataLines is not specified, define defaults
if nargin < 1
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Date", "Tspread", "Threemo", "TedRate", "RegularPE", "RegularPE_1", "RegularPE_2", "RegularPE_3", "RegularPE_4", "RegularPE_5", "RegularPE_6", "RegularPE_7", "RegularPE_8", "RegularPE_9", "RegularPE_10"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Date", "InputFormat", "yyyy-MM-dd");

% Import the data
spx = readtable(filename, opts);

end
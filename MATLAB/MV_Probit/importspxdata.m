%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: /home/precision/GoogleDrive/Datasets/ExcessReturns/spx.csv
%
% Auto-generated by MATLAB on 11-Jun-2020 16:07:15

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = [2, Inf];
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
spx = readtable("/home/precision/GoogleDrive/Datasets/ExcessReturns/spx.csv", opts);


%% Clear temporary variables
clear opts
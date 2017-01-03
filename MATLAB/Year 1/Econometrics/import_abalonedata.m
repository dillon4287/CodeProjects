%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/dillonflannery-valadez/Documents/MATLAB/Econometrics/abalone.data.txt
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2016/01/27 08:24:50

%% Initialize variables.
filename = '/Users/dillonflannery-valadez/Documents/MATLAB/Econometrics/abalone.data.txt';
delimiter = ',';

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
SEX = dataArray{:, 1};
LENGTH = dataArray{:, 2};
DIAMETER = dataArray{:, 3};
HEIGHT = dataArray{:, 4};
WHOLEWEIGHT = dataArray{:, 5};
SHUCKEDWEIGHT = dataArray{:, 6};
VISCERAWEIGHT = dataArray{:, 7};
SHELLWEIGHT = dataArray{:, 8};
RINGS = dataArray{:, 9};


%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;
%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/dillonflannery-valadez/UCI/Dale Poirier/CompAssnData.xlsx
%    Worksheet: Sheet1
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2015/09/08 21:42:52

%% Import the data
[~, ~, raw] = xlsread('/Users/dillonflannery-valadez/UCI/Dale Poirier/CompAssnData.xlsx','Sheet1');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
rGams = reshape([raw{:}],size(raw));

%% Clear temporary variables
clearvars raw R;
%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/dillonflannery-valadez/Google Drive/MATLAB/Year 1/Econometrics/Homework2_Q3/Data_PS2a_S15-2.xlsx
%    Worksheet: Sheet1
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2016/10/12 14:36:02

%% Import the data
data = xlsread('/Users/dillonflannery-valadez/Google Drive/MATLAB/Year 1/Econometrics/Homework2_Q3/Data_PS2a_S15-2.xlsx','Sheet1');

%% Allocate imported array to column variable names
y = data(:,1);
constant = data(:,2);
x_1 = data(:,3);
x_2 = data(:,4);

%% Clear temporary variables
clearvars data raw;
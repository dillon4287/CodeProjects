%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/dillonflannery-valadez/Google Drive/CodeProjects/MATLAB/advanced_macro/Hw4/feds200628.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/02/06 16:15:07

%% Initialize variables.
filename = '/Users/dillonflannery-valadez/Google Drive/CodeProjects/MATLAB/advanced_macro/Hw4/feds200628.csv';
delimiter = ',';
startRow = 2;

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If
% an error occurs for a different file, try regenerating the code from the
% Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]
    % Converts text in the input cell array to numbers. Replaced non-numeric text
    % with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]);
rawCellColumns = raw(:, 1);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
VarName1 = rawCellColumns(:, 1);
SVENY01 = cell2mat(rawNumericColumns(:, 1));
SVENY02 = cell2mat(rawNumericColumns(:, 2));
SVENY03 = cell2mat(rawNumericColumns(:, 3));
SVENY04 = cell2mat(rawNumericColumns(:, 4));
SVENY05 = cell2mat(rawNumericColumns(:, 5));
SVENY06 = cell2mat(rawNumericColumns(:, 6));
SVENY07 = cell2mat(rawNumericColumns(:, 7));
SVENY08 = cell2mat(rawNumericColumns(:, 8));
SVENY09 = cell2mat(rawNumericColumns(:, 9));
SVENY10 = cell2mat(rawNumericColumns(:, 10));
SVENY11 = cell2mat(rawNumericColumns(:, 11));
SVENY12 = cell2mat(rawNumericColumns(:, 12));
SVENY13 = cell2mat(rawNumericColumns(:, 13));
SVENY14 = cell2mat(rawNumericColumns(:, 14));
SVENY15 = cell2mat(rawNumericColumns(:, 15));
SVENY16 = cell2mat(rawNumericColumns(:, 16));
SVENY17 = cell2mat(rawNumericColumns(:, 17));
SVENY18 = cell2mat(rawNumericColumns(:, 18));
SVENY19 = cell2mat(rawNumericColumns(:, 19));
SVENY20 = cell2mat(rawNumericColumns(:, 20));
SVENY21 = cell2mat(rawNumericColumns(:, 21));
SVENY22 = cell2mat(rawNumericColumns(:, 22));
SVENY23 = cell2mat(rawNumericColumns(:, 23));
SVENY24 = cell2mat(rawNumericColumns(:, 24));
SVENY25 = cell2mat(rawNumericColumns(:, 25));
SVENY26 = cell2mat(rawNumericColumns(:, 26));
SVENY27 = cell2mat(rawNumericColumns(:, 27));
SVENY28 = cell2mat(rawNumericColumns(:, 28));
SVENY29 = cell2mat(rawNumericColumns(:, 29));
SVENY30 = cell2mat(rawNumericColumns(:, 30));
SVENPY01 = cell2mat(rawNumericColumns(:, 31));
SVENPY02 = cell2mat(rawNumericColumns(:, 32));
SVENPY03 = cell2mat(rawNumericColumns(:, 33));
SVENPY04 = cell2mat(rawNumericColumns(:, 34));
SVENPY05 = cell2mat(rawNumericColumns(:, 35));
SVENPY06 = cell2mat(rawNumericColumns(:, 36));
SVENPY07 = cell2mat(rawNumericColumns(:, 37));
SVENPY08 = cell2mat(rawNumericColumns(:, 38));
SVENPY09 = cell2mat(rawNumericColumns(:, 39));
SVENPY10 = cell2mat(rawNumericColumns(:, 40));
SVENPY11 = cell2mat(rawNumericColumns(:, 41));
SVENPY12 = cell2mat(rawNumericColumns(:, 42));
SVENPY13 = cell2mat(rawNumericColumns(:, 43));
SVENPY14 = cell2mat(rawNumericColumns(:, 44));
SVENPY15 = cell2mat(rawNumericColumns(:, 45));
SVENPY16 = cell2mat(rawNumericColumns(:, 46));
SVENPY17 = cell2mat(rawNumericColumns(:, 47));
SVENPY18 = cell2mat(rawNumericColumns(:, 48));
SVENPY19 = cell2mat(rawNumericColumns(:, 49));
SVENPY20 = cell2mat(rawNumericColumns(:, 50));
SVENPY21 = cell2mat(rawNumericColumns(:, 51));
SVENPY22 = cell2mat(rawNumericColumns(:, 52));
SVENPY23 = cell2mat(rawNumericColumns(:, 53));
SVENPY24 = cell2mat(rawNumericColumns(:, 54));
SVENPY25 = cell2mat(rawNumericColumns(:, 55));
SVENPY26 = cell2mat(rawNumericColumns(:, 56));
SVENPY27 = cell2mat(rawNumericColumns(:, 57));
SVENPY28 = cell2mat(rawNumericColumns(:, 58));
SVENPY29 = cell2mat(rawNumericColumns(:, 59));
SVENPY30 = cell2mat(rawNumericColumns(:, 60));
SVENF01 = cell2mat(rawNumericColumns(:, 61));
SVENF02 = cell2mat(rawNumericColumns(:, 62));
SVENF03 = cell2mat(rawNumericColumns(:, 63));
SVENF04 = cell2mat(rawNumericColumns(:, 64));
SVENF05 = cell2mat(rawNumericColumns(:, 65));
SVENF06 = cell2mat(rawNumericColumns(:, 66));
SVENF07 = cell2mat(rawNumericColumns(:, 67));
SVENF08 = cell2mat(rawNumericColumns(:, 68));
SVENF09 = cell2mat(rawNumericColumns(:, 69));
SVENF10 = cell2mat(rawNumericColumns(:, 70));
SVENF11 = cell2mat(rawNumericColumns(:, 71));
SVENF12 = cell2mat(rawNumericColumns(:, 72));
SVENF13 = cell2mat(rawNumericColumns(:, 73));
SVENF14 = cell2mat(rawNumericColumns(:, 74));
SVENF15 = cell2mat(rawNumericColumns(:, 75));
SVENF16 = cell2mat(rawNumericColumns(:, 76));
SVENF17 = cell2mat(rawNumericColumns(:, 77));
SVENF18 = cell2mat(rawNumericColumns(:, 78));
SVENF19 = cell2mat(rawNumericColumns(:, 79));
SVENF20 = cell2mat(rawNumericColumns(:, 80));
SVENF21 = cell2mat(rawNumericColumns(:, 81));
SVENF22 = cell2mat(rawNumericColumns(:, 82));
SVENF23 = cell2mat(rawNumericColumns(:, 83));
SVENF24 = cell2mat(rawNumericColumns(:, 84));
SVENF25 = cell2mat(rawNumericColumns(:, 85));
SVENF26 = cell2mat(rawNumericColumns(:, 86));
SVENF27 = cell2mat(rawNumericColumns(:, 87));
SVENF28 = cell2mat(rawNumericColumns(:, 88));
SVENF29 = cell2mat(rawNumericColumns(:, 89));
SVENF30 = cell2mat(rawNumericColumns(:, 90));
SVEN1F01 = cell2mat(rawNumericColumns(:, 91));
SVEN1F04 = cell2mat(rawNumericColumns(:, 92));
SVEN1F09 = cell2mat(rawNumericColumns(:, 93));
BETA0 = cell2mat(rawNumericColumns(:, 94));
BETA1 = cell2mat(rawNumericColumns(:, 95));
BETA2 = cell2mat(rawNumericColumns(:, 96));
BETA3 = cell2mat(rawNumericColumns(:, 97));
TAU1 = cell2mat(rawNumericColumns(:, 98));
TAU2 = cell2mat(rawNumericColumns(:, 99));


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;
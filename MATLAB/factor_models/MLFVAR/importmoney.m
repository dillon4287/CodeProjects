function mpy = importfile1(filename, startRow, endRow)
%IMPORTFILE1 Import numeric data from a text file as a matrix.
%   MPY = IMPORTFILE1(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   MPY = IMPORTFILE1(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   mpy = importfile1('mpy.csv', 2, 52);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2019/05/06 19:31:22

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
%   column17: double (%f)
%	column18: double (%f)
%   column19: double (%f)
%	column20: double (%f)
%   column21: double (%f)
%	column22: double (%f)
%   column23: double (%f)
%	column24: double (%f)
%   column25: double (%f)
%	column26: double (%f)
%   column27: double (%f)
%	column28: double (%f)
%   column29: double (%f)
%	column30: double (%f)
%   column31: double (%f)
%	column32: double (%f)
%   column33: double (%f)
%	column34: double (%f)
%   column35: double (%f)
%	column36: double (%f)
%   column37: double (%f)
%	column38: double (%f)
%   column39: double (%f)
%	column40: double (%f)
%   column41: double (%f)
%	column42: double (%f)
%   column43: double (%f)
%	column44: double (%f)
%   column45: double (%f)
%	column46: double (%f)
%   column47: double (%f)
%	column48: double (%f)
%   column49: double (%f)
%	column50: double (%f)
%   column51: double (%f)
%	column52: double (%f)
%   column53: double (%f)
%	column54: double (%f)
%   column55: double (%f)
%	column56: double (%f)
%   column57: double (%f)
%	column58: double (%f)
%   column59: double (%f)
%	column60: double (%f)
%   column61: double (%f)
%	column62: double (%f)
%   column63: double (%f)
%	column64: double (%f)
%   column65: double (%f)
%	column66: double (%f)
%   column67: double (%f)
%	column68: double (%f)
%   column69: double (%f)
%	column70: double (%f)
%   column71: double (%f)
%	column72: double (%f)
%   column73: double (%f)
%	column74: double (%f)
%   column75: double (%f)
%	column76: double (%f)
%   column77: double (%f)
%	column78: double (%f)
%   column79: double (%f)
%	column80: double (%f)
%   column81: double (%f)
%	column82: double (%f)
%   column83: double (%f)
%	column84: double (%f)
%   column85: double (%f)
%	column86: double (%f)
%   column87: double (%f)
%	column88: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
mpy = table(dataArray{1:end-1}, 'VariableNames', {'Year','CanadaGDP','CanadaINF','CanadaM4','USAGDP','USAINF','USAM4','AustriaGDP','AustriaINF','AustriaM4','BelgiumGDP','BelgiumINF','BelgiumM4','DenmarkGDP','DenmarkINF','DenmarkM4','FinlandGDP','FinlandINF','FinlandM4','FranceGDP','FranceINF','FranceM4','GermanyGDP','GermanyINF','GermanyM4','IsraelGDP','IsraelINF','IsraelM4','ItalyGDP','ItalyINF','ItalyM4','NetherlandsGDP','NetherlandsINF','NetherlandsM4','NorwayGDP','NorwayINF','NorwayM4','PortugalGDP','PortugalINF','PortugalM4','SwedenGDP','SwedenINF','SwedenM4','UKGDP','UKINF','UKM4','AustraliaGDP','AustraliaINF','AustraliaM4','JapanGDP','JapanINF','JapanM4','SingaporeGDP','SingaporeINF','SingaporeM4','ColombiaGDP','ColombiaINF','ColombiaM4','MexicoGDP','MexicoINF','MexicoM4','PeruGDP','PeruINF','PeruM4','EgyptGDP','EgyptINF','EgyptM4','GreeceGDP','GreeceINF','GreeceM4','SafricaGDP','SafricaINF','SafricaM4','TurkeyGDP','TurkeyINF','TurkeyM4','IndiaGDP','IndiaINF','IndiaM4','KoreaGDP','KoreaINF','KoreaM4','PakistanGDP','PakistanINF','PakistanM4','NigeriaGDP','NigeriaINF','NigeriaM4'});

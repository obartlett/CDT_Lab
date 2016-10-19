function [ time, Tideheight, TrueTideHeight, starttime ] = ImportSotonmetData( filename )

%% Import Sotonmet Data (Based on Matlab generated code)

%Initialize variables:
%filename = strcat(pwd,'/sotonmet.txt');
delimiter = ',';
% Format string for each line of text:
formatSpec = '%s%*s%*s%*s%*s%f%*s%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

fileID = fopen(filename,'r'); % Open the text file.

% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec,'HeaderLines', 1, 'Delimiter', delimiter,  'ReturnOnError', true);

fclose(fileID); %close file.

ISOTime = dataArray{:, 1};
Tideheight = dataArray{:, 2};
TrueTideHeight = dataArray{:, 3};

Tideheight(strcmp('2007-05-28T16:10:00',ISOTime))=[];
TrueTideHeight(strcmp('2007-05-28T16:10:00',ISOTime))=[];
ISOTime(strcmp('2007-05-28T16:10:00',ISOTime))=[];


time = datenum(ISOTime,'yyyy-mm-ddTHH:MM:SS'); %change Date String to actual numbers
starttime = time(1); %So that times are sensible and not unneccesarily long

time = time - starttime;

%emptycells = isnan(Tideheight); %Used to remove empty rows

%time(emptycells) = [];%Remove empty rows from time vector
%Tideheight(emptycells) = []; % Remove empty rows from Tide Heights vector


clearvars filename delimiter formatSpec fileID dataArray ans ISOTime emptycells;

end


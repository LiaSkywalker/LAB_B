%% This code plotting the Voltage on the diode as a function of time
%put this script in the same direcory the data in.
% AM- Amplitude modulation measurements!

%% clear workspace
clc
close all

%% import measures data 

files=dir('*.csv');
OuterStruct = struct ;

for k=1:length(files) %repeat for every file
    
    [T, Vdiode, Vsource] =importfile(files(k).name); %import data to tuple vector
    fileName = files(k).name(1:end-4);
    
    Y= Vdiode;%����� 
    Rmlist = isnan(T);
    T(Rmlist) = [];
    Y(Rmlist) = [];
    
    Y=Y+abs(min(Y));
    Y=smooth(smooth(Y));
    [localmax,locs]=findpeaks(Y,'MinPeakProminence',0.1);
    
    currentStruct = struct('fileName',fileName,...
        'Times',T,'VmeasurePeaks',localmax,'Vsource',Vsource, 'Vsmoove',Y,'Vdiode',Vdiode);
    OuterStruct(k).currentData = currentStruct;
    
%%     plot biforcations graph:
    plot(OuterStruct(k).currentData.Times(locs),OuterStruct(k).currentData.VmeasurePeaks,'.');

end
%% print graphs

for k=1:length(files)
    f= figure();
    handles(k) = axes('Parent',f);
    set(gca,'fontsize',12)
    hold all;
    plot(OuterStruct(k).currentData.Vsource,OuterStruct(k).currentData.Vdiode,'markersize',12,'Parent',handles(k))
    title(OuterStruct(k).currentData.fileName)
    xlabel('Source voltage [V]')
    ylabel('Voltage measured [V]')

end

%% import data functions
function [Time, Vdiode, Vsource] = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  [TIME, VDIODE, VSOURCE] = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as column
%  vectors.
%
%  [TIME, VDIODE, VSOURCE] = IMPORTFILE(FILE, DATALINES) reads data for
%  the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  [Time, Vdiode, Vsource] = importfile("C:\Users\zrobb\Documents\�������\������\����� �\����\���� 2 ����� RLD �� AC �AM\������ ������\0.1.csv", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 23-Jun-2021 16:45:07

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Time", "Vdiode", "Var6", "Var7", "Var8", "Var9", "Var10", "Vsource"];
opts.SelectedVariableNames = ["Time", "Vdiode", "Vsource"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "string", "string", "string", "string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var7", "Var8", "Var9", "Var10"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var7", "Var8", "Var9", "Var10"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
Time = tbl.Time;
Vdiode = tbl.Vdiode;
Vsource = tbl.Vsource;
end
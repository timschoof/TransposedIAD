%% demoPlayAndReturnResponse3I3AFC

clear
close all
IAD='ILD';
if strcmp(IAD, 'ITD')
    ITD = 1200; % in us -- 12500 is 1/2 period for 40 Hx modulation
    starting_SNR=20*log10(ITD/100);
    MIN_change_dB = 1;
else
    starting_SNR=4;
    MIN_change_dB = 0.5;
    START_change_dB=2;
end

p=TransposedIADsParseArgs('SR', 'starting_SNR',starting_SNR, ...
    'MaximalDifference', 1, 'IAD', IAD, ...
    'START_change_dB', START_change_dB, 'MIN_change_dB', MIN_change_dB, ...
    'usePlayrec', 0, 'BackNzLevel', -100, ......
    'trackAbsThreshold', 0, 'GoButton', 0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', 'LongMaskerNoise', 3000,...
    'usePlayrec', 0, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG', 0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
%% read in all the necessary faces for feedback

if ~strcmp(p.FeedBack, 'None')
    FacesDir = fullfile('Faces',p.FacePixDir,'');
    SmileyFace = imread(fullfile(FacesDir,'smile24.bmp'),'bmp');
    WinkingFace = imread(fullfile(FacesDir,'wink24.bmp'),'bmp');
    FrownyFace = imread(fullfile(FacesDir,'frown24.bmp'),'bmp');
    %ClosedFace = imread(fullfile(FacesDir,'closed24.bmp'),'bmp');
    %OpenFace = imread(fullfile(FacesDir,'open24.bmp'),'bmp');
    %BlankFace = imread(fullfile(FacesDir,'blank24.bmp'),'bmp');
    p.CorrectImage=SmileyFace;
    p.IncorrectImage=FrownyFace;
end

%% generate the appropriate sounds
[w, wInQuiet, wUntransposed]=GenerateIADtriple(p);
%% ensure no overload
% function [OutWave, flag] = NoClipStereo(InWave,message)
[w, flag] = NoClipStereo(w);

% function [response,p] = PlayAndReturnResponse3I3AFC(Wave2Play,trial,p)
[response,p] = PlayAndReturnResponse3I3AFC(w,1,p);
delete(findobj('Type','figure'));
return

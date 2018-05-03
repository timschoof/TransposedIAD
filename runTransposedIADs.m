%%
clear
close all
IAD='ILD';
if strcmp(IAD, 'ITD')
    ITD = 1200; % in us -- 12500 is 1/2 period for 40 Hx modulation
    starting_SNR=20*log10(ITD/100);
    START_change_dB=4;        
    MIN_change_dB = 1;
else
    starting_SNR=6;
    MIN_change_dB = 0.25;
    START_change_dB=2;    
end

TransposedIADs('SER', 'starting_SNR',starting_SNR, ...
    'ModulationRate', 100, ...
    'MaximalDifference', 1, 'IAD', IAD, ...
    'START_change_dB', START_change_dB, 'MIN_change_dB', MIN_change_dB, ...
    'usePlayrec', 0, ...
    'trackAbsThreshold', 0, 'GoButton', 1, ...
    'VolumeSettingsFile', 'VolumeSettings4kHzILD.txt', 'LongMaskerNoise', 3000,...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG', 0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
return
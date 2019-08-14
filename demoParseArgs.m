%%
clear
close all
IAD='ILD';
TaskFormat='3I-3AFC';
TaskFormat='2I-2AFC';
TranspositionFreq = 4000;
TranspositionFreq = 0;

if strcmp(IAD, 'ITD')
    ITD = 650; % in us -- 12500 is 1/2 period for 40 Hz modulation
    starting_SNR=20*log10(ITD/100);
    START_change_dB=6;
    MIN_change_dB = 1;
else
    starting_SNR=3;
    MIN_change_dB = 0.25;
    START_change_dB=1;
    MIN_SNR_dB=0.25; % minimal difference: for ILD only
    % Remember, it's twice this!
    InitialDescentMinimum=.5;
end    

myArgin = {'SR', 'starting_SNR',starting_SNR, ...
        'TranspositionFreq', TranspositionFreq, ...
        'ModulationRate', 125, ...
        'TaskFormat', TaskFormat, ...
        'MaximalDifference', 1, 'IAD', IAD, ...
        'START_change_dB', START_change_dB, 'MIN_change_dB', MIN_change_dB, ...
        'usePlayrec', 0, 'RMEslider', 'FALSE', ...
        'trackAbsThreshold', 0, 'GoButton', 1, ...
        'BackNzLevel', -100, ...
        'TranspositionFreq', 4000, ...
        'ModulationPhase', 0, ...
        'VolumeSettingsFile', 'VolumeSettings4kHzILD.txt', 'LongMaskerNoise', 1500,...
        'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG', 0};
    
    p=TransposedIADsParseArgs(myArgin{1},myArgin{2:end});
    p.TranspositionFreq
    
    
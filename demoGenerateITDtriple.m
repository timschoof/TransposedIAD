function demoGenerateITDtriple(ITD, Order)

%ITD = 12500; % in us -- 12500 is 1/2 period for 40 Hz modulation
starting_SNR=20*log10(ITD/100);
p=TransposedIADsParseArgs('L27', 'starting_SNR',starting_SNR, ...
    'ModulationRate', 100, ...
    'LeadingEar', 'L', 'Order', Order, ...
    'preSilence', 300, ...
    'MaximalDifference', 1, ...
    'NoiseDuration', 500, 'LongMaskerNoise', 3000);

% function [w, wInQuiet, wUntransposed]=GenerateITDtriple(p)
[w, wInQuiet, wUntransposed]=GenerateITDtriple(p);
audiowrite(sprintf('ITDtriple-%d-o%d.wav',ITD,p.Order),w,p.SampFreq)
audiowrite(sprintf('ITDtripleUn-%d-o%d.wav',ITD,p.Order),wUntransposed,p.SampFreq)

sound(w,p.SampFreq)
% sound(wUntransposed,p.SampFreq)

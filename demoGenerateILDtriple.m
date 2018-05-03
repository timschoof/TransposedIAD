function demoGenerateILDtriple(ILD, Order)

% Order=3;
starting_SNR=ILD;
p=TransposedIADsParseArgs('L27', 'IAD', 'ILD', 'starting_SNR',starting_SNR, ...
    'LeadingEar', 'L', 'Order', Order, ...
    'ModulationRate', 100, ...
    'preSilence', 300, ...
    'MaximalDifference', 1, ...
    'LongMaskerNoise', 3000);

% 'ModulationRate', 500, ...

% function [w, wInQuiet, wUntransposed]=GenerateITDtriple(p)
[w, wInQuiet, wUntransposed]=GenerateIADtriple(p);
audiowrite(sprintf('ILDtriple-%d-o%d.wav',starting_SNR,p.Order),w,p.SampFreq)
audiowrite(sprintf('ILDtripleUn-%d-o%d.wav',starting_SNR,p.Order),wUntransposed,p.SampFreq)

sound(w,p.SampFreq)
% plot(w)
% sound(wUntransposed,p.SampFreq)

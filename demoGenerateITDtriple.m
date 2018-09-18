function demoGenerateITDtriple(ITD, Order)

%ITD = 12500; % in us -- 12500 is 1/2 period for 40 Hz modulation
starting_SNR=20*log10(ITD/100);
p=TransposedIADsParseArgs('L27', 'starting_SNR',starting_SNR, ...
    'ModulationRate', 100, ...
    'LeadingEar', 'L', 'Order', Order, ...
    'preSilence', 300, ...
    'MaximalDifference', 1, ...
    'rms2use', 0.1, ...
<<<<<<< HEAD
    'BackNzLevel', -100, ...
    'usePlayrec', 0, ...
=======
    'BackNzLevel', -10, ...
>>>>>>> f639f2453596ab005ca8d311f9d4d36be947549c
    'NoiseDuration', 500, 'LongMaskerNoise', 3000);

% function [w, wInQuiet, wUntransposed]=GenerateITDtriple(p)
[w, wInQuiet, wUntransposed]=GenerateIADtriple(p);
audiowrite(sprintf('ITDtriple-%d-o%d.wav',ITD,p.Order),w,p.SampFreq)
audiowrite(sprintf('ITDtripleUn-%d-o%d.wav',ITD,p.Order),wUntransposed,p.SampFreq)
audiowrite(sprintf('ITDtripleQT-%d-o%d.wav',ITD,p.Order),wInQuiet,p.SampFreq)

sound(w,p.SampFreq)
pwelch(w,[],[],[],p.SampFreq), ylim([-140 -20])
% sound(wUntransposed,p.SampFreq)

function demoGenerateILDduple(ILD, Order)

% Order=1;
starting_SNR=ILD;
p=TransposedIADsParseArgs('L27', 'IAD', 'ILD', 'starting_SNR',starting_SNR, ...
    'LeadingEar', 'L', 'Order', Order, ...
    'ModulationRate', 100, ...
    'preSilence', 50, ...
    'usePlayrec', 0, 'BackNzLevel', -100, ......
    'MaximalDifference', 1, ...
    'LongMaskerNoise', 1500);

% 'ModulationRate', 500, ...

% function [w, wInQuiet, wUntransposed]=GenerateITDtriple(p)
[w, wInQuiet, wUntransposed]=GenerateIADduple(p);
audiowrite(sprintf('ILDtriple-%d-o%d.wav',starting_SNR,p.Order),w,p.SampFreq)
audiowrite(sprintf('ILDtripleUn-%d-o%d.wav',starting_SNR,p.Order),wUntransposed,p.SampFreq)
audiowrite(sprintf('ILDtripleQT-%d-o%d.wav',starting_SNR,p.Order),wInQuiet,p.SampFreq)


sound(w,p.SampFreq)
pwelch(w,[],[],[],p.SampFreq)
% figure, plot(w)
t= (0:length(w)-1)/p.SampFreq;
plot(t,w(:,1),t,w(:,2)+1), legend({"L","R"})

% sound(wUntransposed,p.SampFreq)

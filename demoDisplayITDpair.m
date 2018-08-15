function demoDisplayITDpair(ITD)
% starting_SNR=32;
% ITD = 100*10^(starting_SNR/20)
% close all
% clear
% ITD=1000;
Order=1;
SignalDuration= 20; % 50
ISI=5; % 20
SampFreq=44100;

%  18.0618 = 800 us

%ITD = 12500; % in us -- 12500 is 1/2 period for 40 Hz modulation
starting_SNR=20*log10(ITD/100);

p=TransposedIADsParseArgs('L27', 'starting_SNR',starting_SNR, ...
    'ModulationRate', 125, ...
    'LeadingEar', 'L', 'Order', Order, ...
    'preSilence', 00, ...
    'SampFreq', SampFreq, ...
    'MaximalDifference', 1, ...
    'rms2use', 0.1, ...
    'BackNzLevel', -100, ...
    'RiseFall', 0, 'ISI', ISI, 'SignalDuration', SignalDuration, ...
    'NoiseDuration', SignalDuration, ...
    'usePlayrec', 0, ...
    'LongMaskerNoise', 1000*(3*samplify(SignalDuration,SampFreq)+2*samplify(ISI,SampFreq))/SampFreq);

%  samplify(3*SignalDuration+2*ISI, SampFreq)

% function [w, wInQuiet, wUntransposed]=GenerateITDtriple(p)
[w, wInQuiet, wUntransposed]=GenerateIADtriple(p);
% restrict range of plotting to two pulses
restrictedTime = 2*p.SignalDuration+p.ISI;
rT=((0:samplify(restrictedTime,p.SampFreq)-1)/p.SampFreq);
t=(0:(length(w)-1))/p.SampFreq;
% plot(rT, w(1:length(rT),:))
plot(rT, w(1:length(rT),1),rT, 0.55 + w(1:length(rT),2))
grid on
title(sprintf('ITD= %d us at %d Hz, = %4.1f dB re 100 us',ITD, p.ModulationRate, starting_SNR));
saveas(gcf, sprintf('ITD_%d_%d_dB_%d_Hz.png',ITD, round(starting_SNR), p.ModulationRate))
saveas(gcf, sprintf('ITD_%d_%d_dB_%d_Hz.fig',ITD, round(starting_SNR), p.ModulationRate))

audiowrite(sprintf('ITDtriple-%d-o%d.wav',ITD,p.Order),w,p.SampFreq)
sound(w,p.SampFreq)
return
audiowrite(sprintf('ITDtripleUn-%d-o%d.wav',ITD,p.Order),wUntransposed,p.SampFreq)
audiowrite(sprintf('ITDtripleQT-%d-o%d.wav',ITD,p.Order),wInQuiet,p.SampFreq)


% pwelch(w,[],[],[],p.SampFreq), ylim([-140 -20])
% sound(wUntransposed,p.SampFreq)

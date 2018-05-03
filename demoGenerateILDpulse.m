clear
close all
starting_SNR = 10; % in dB
p=TransposedIADsParseArgs('L27', 'starting_SNR',starting_SNR, ...
    'IAD', 'ILD', ...
    'LeadingEar', 'L', 'NoiseDuration', 500, 'LongMaskerNoise', 3000);

% function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
[w, untransposed]=GenerateILDpulse(1, p);
audiowrite('ILDpulse.wav',w,p.SampFreq)
audiowrite('ILDpulseUN.wav',untransposed,p.SampFreq)


return


pwelch(w,[],[],[],p.SampFreq)
% figure
% plot([Nz flatNz])
audiowrite('demoSAMtriple.wav',w,p.SampFreq)

return


pwelch(w,[],[],[],p.SampFreq)
figure
plot([w])
plot(Tn)

size(w)
plot(w)
sound(w,p.SampFreq)

%w(:,2)=0;




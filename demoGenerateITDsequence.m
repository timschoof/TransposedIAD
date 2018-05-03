clear
close all
maxITD = 1200;
nITDs = 8;
ITDs = ones(8) * maxITD;
leadingEar = 'LRLRLRLRLRLR';
SampFreq=44100;
ISI = zeros(samplify(300, SampFreq),2);

y = [];
for i=1:length(ITDs)
    starting_SNR=20*log10(ITDs(i)/100);
    p=TransposedITDParseArgs('L27', 'starting_SNR',starting_SNR, ...
        'SampFreq', SampFreq, ...
        'LeadingEar', leadingEar(i), 'NoiseDuration', 500, 'LongMaskerNoise', 000);
    % function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
    [w, untransposed]=GenerateITDpulse(1, p);
    y = vertcat(y,w, ISI);
end
audiowrite(sprintf('ITD-alternating-%d.wav',maxITD),y,SampFreq)
% audiowrite('ITDpulseUN.wav',untransposed,p.SampFreq)
return


clear
close all
ITDs = [50, 100, 200, 400, 800, 1200];
ITDs = [sort(ITDs, 'descend') 0 ITDs ];
leadingEar = 'LLLLLLLRRRRRR';
SampFreq=44100;
ISI = zeros(samplify(300, SampFreq),2);

y = [];
for i=1:length(ITDs)
    starting_SNR=20*log10(ITDs(i)/100);
    p=TransposedITDParseArgs('L27', 'starting_SNR',starting_SNR, ...
        'SampFreq', SampFreq, ...
        'LeadingEar', leadingEar(i), 'NoiseDuration', 500, 'LongMaskerNoise', 000);
    % function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
    [w, untransposed]=GenerateITDpulse(1, p);
    y = vertcat(y,w, ISI);
end
audiowrite('ITDsequence.wav',y,SampFreq)
% audiowrite('ITDpulseUN.wav',untransposed,p.SampFreq)
return


ITD = 1200; % in us -- 12500 is 1/2 period for 40 Hx modulation





return


% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
p.Order=1;
[w, AMnz, modulator] = GenerateSAMtriple(p);
% pwelch(w,[],[],[],p.SampFreq)
t=(0:(length(w)-1))/p.SampFreq;
%figure
plot(t,w)
audiowrite('demoSAMtriple.wav',w,p.SampFreq)

return



%% GenerateSAMtriple with a long masker
clear
close all
p=NoisySAMParseArgs('L27', 'starting_SNR',0, 'propLongMaskerPreTarget', 0.8);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
p.order=2;
[w, AMnz] = GenerateSAMtriple(p);
pwelch(w,[],[],[],p.SampFreq)
% figure
% plot([Nz flatNz])
audiowrite('demoSAMtriple.wav',w,p.SampFreq)

return
%% -------------------------------------------------------------------
%% GenerateSAMnz
clear
close all
p=NoisySAMParseArgs('L27', 'starting_SNR',-100);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
ModulationPresent=1;


[Nz, flatNz] = GenerateSAMnz(ModulationPresent, p);
% pwelch(Nz,[],[],[],p.SampFreq)
% figure
% plot([Nz flatNz])
audiowrite('demoSAM.wav',Nz,p.SampFreq)

return
w=Nz; % for long noise

pwelch(w,[],[],[],p.SampFreq)
figure
plot([w])
plot(Tn)

size(w)
plot(w)
sound(w,p.SampFreq)

%w(:,2)=0;




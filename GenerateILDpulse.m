function [w, untransposed]=GenerateILDpulse(ILDpresent, p)
%
% ILDPresent = 0 or 1
%
TTSamples=samplify(p.SignalDuration,p.SampFreq);
if ILDpresent
    if ~p.trackAbsThreshold % the normal thing to do
        ILD= 10^(-p.SNR_dB/20);
    else
        ILD=1;
    end
else
    ILD=1;
end

% generate the initial sinusoid
t=(0:TTSamples-1)'/p.SampFreq;
L = cos(2*pi*p.ModulationRate*t+p.ModulationPhase);
R = L*ILD;

% plot(t,L,t,R)
% function y = TransposeSounds(w,p)
Lt = TransposeSounds(L,p);
% Rt = Lt; % No ILD on transposed sounds yet
% plot(t,Lt,t,Rt)
% normalise transposed sounds to the appropriate rms
Lt = p.rms2use * Lt/rms(Lt);
Rt = Lt*ILD;

%% default: L leading ear
%   alter if necessary
if p.LeadingEar=='R'
    Lx = R; R = L; L=Lx;
    Lx = Rt; Rt = Lt; Lt=Lx;    
end

% put rises and falls on the sound pulses,
% function s=taper(wave, rise, fall, p.SampFreq, type)
Lt=taper(Lt, p.RiseFall, p.RiseFall, p.SampFreq);
Rt=taper(Rt, p.RiseFall, p.RiseFall, p.SampFreq);
w=[Lt,Rt];
L=taper(L, p.RiseFall, p.RiseFall, p.SampFreq);
R=taper(R, p.RiseFall, p.RiseFall, p.SampFreq);
untransposed=0.8*[L,R];

function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
%
% ITDPresent = 0 or 1
%   Version 1.0 - July 2018
%   Version 2.0 - August 2018
%       couldn't do untransposed sounds. Corrected.
%
TTSamples=samplify(p.SignalDuration,p.SampFreq);
if ITDpresent
    if ~p.trackAbsThreshold % the normal thing to do
        ITD=100 * 10^(p.SNR_dB/20);
    else
        ITD=100* 10^(p.ITDAbsThreshold/20);
    end
else
    ITD=0;
end

% generate the initial sinusoid
t=(0:TTSamples-1)'/p.SampFreq;
L = cos(2*pi*p.ModulationRate*t+p.ModulationPhase);
R = cos(2*pi*p.ModulationRate*(t-ITD/10^6)+p.ModulationPhase); % delay the right ear
%% default: L leading ear
%   alter if necessary
if p.LeadingEar=='R'
    Lt = R;
    R = L;
    L=Lt;
end
% plot(t,L,t,R), legend({'L','R'})
% tSh=(1:ceil(3*p.SampFreq/p.ModulationRate)); 
% plot(t(tSh),L(tSh),t(tSh),R(tSh)), legend({'L','R'}) 

if p.TranspositionFreq>0
    % function y = TransposeSounds(w,p)
    Lt = TransposeSounds(L,p);
    Rt = TransposeSounds(R,p);
    % figure, plot(t,Lt,t,Rt), legend({'L','R'})
    % figure, plot(t(tSh),Lt(tSh),t(tSh),Rt(tSh)), legend({'L','R'})
    % normalise transposed sounds to the appropriate rms
    Lt = p.rms2use * Lt/rms(Lt);
    Rt = p.rms2use * Rt/rms(Rt);
    % put rises and falls on the sound pulses,
    % function s=taper(wave, rise, fall, p.SampFreq, type)
    Lt=taper(Lt, p.RiseFall, p.RiseFall, p.SampFreq);
    Rt=taper(Rt, p.RiseFall, p.RiseFall, p.SampFreq);
    w=[Lt,Rt];
    L=taper(L, p.RiseFall, p.RiseFall, p.SampFreq);
    R=taper(R, p.RiseFall, p.RiseFall, p.SampFreq);
    untransposed=0.8*[L,R];
else % here are the untransposed sounds
    % normalise  to the appropriate rms
    L = p.rms2use * L/rms(L);
    R = p.rms2use * R/rms(R);
    % put rises and falls on the sound pulses,
    % function s=taper(wave, rise, fall, p.SampFreq, type)
    L=taper(L, p.RiseFall, p.RiseFall, p.SampFreq);
    R=taper(R, p.RiseFall, p.RiseFall, p.SampFreq);
    w=[L,R];
    untransposed=w;
end


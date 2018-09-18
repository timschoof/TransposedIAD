function measureLevelsInWavFiles(varargin)

% default wav directory
wavDir='0-wavsOut';

%% get control parameters by picking up defaults and specified values from args
if ~rem(nargin,2)
    error('You should not have an even number of input arguments');
end
p=TransposedIADsParseArgs(varargin{1},varargin{2:end});

% get the name of a wav file
[wavFile,path] = uigetfile(fullfile(wavDir, '*.wav'));

[y, SampFreq]=audioread(fullfile(path,wavFile));
disp(wavFile)
t=1000*(0:length(y)-1)/SampFreq;
offsetPlots = 2*abs(max(y));
plot(t,y(:,1)+offsetPlots,t,y(:,2)), legend({'L', 'R'},'Location','best')
% draw lines at significant time points -- 
% but need to take account of type of file
if wavFile(1)=='Q' || wavFile(1)=='U' % no noise present so just ISI + sound pulses
    TTSamples=samplify(p.SignalDuration,p.SampFreq);
    ISISamples=samplify(p.ISI,p.SampFreq);
    riseFallSamples=samplify(p.RiseFall,p.SampFreq);
    vline(p.RiseFall), vline(p.SignalDuration-p.RiseFall), vline(p.SignalDuration)
    vline(p.ISI), vline(p.RiseFall+p.ISI+p.SignalDuration), vline(2*p.SignalDuration+p.ISI-p.RiseFall)
    vline(2*p.SignalDuration+p.ISI), vline(p.SignalDuration+p.ISI)
end
for pulse=1:2
    % select out the pulse only
    s = y(1+(pulse-1)*(TTSamples+ISISamples):TTSamples+(pulse-1)*(TTSamples+ISISamples),:);
    fprintf('Pulse %d (L R ILD) all: %5.2f %5.2f %5.2f (L R ILD) no RT: ', pulse, ...
        dBrms(s(:,1)),dBrms(s(:,2)),dBrms(s(:,1))-dBrms(s(:,2)));    
    s = s(1+riseFallSamples:end-riseFallSamples,:);
    fprintf(' %5.2f %5.2f %5.2f\n', dBrms(s(:,1)),dBrms(s(:,2)),dBrms(s(:,1))-dBrms(s(:,2))); 
end
        



%% timing values
% p.addParameter('RiseFall', 50, @isnumeric);
% p.addParameter('ISI', 400, @isnumeric);
% p.addParameter('SignalDuration', 400, @isnumeric);
% p.addParameter('NoiseDuration', 500, @isnumeric);
% % the duration of the masker pulse. If longer than the target, the target is
% % centred in it. Only relevant if LongMaskerNoise=0
% p.addParameter('LongMaskerNoise', 2400, @isnumeric);
% % if 0, masker noise is pulsed along with target intervals
% % if >0 = continuous through triple at given duration (ms)
% p.addParameter('propLongMaskerPreTarget', 0.9, @isnumeric);
% % a parameter to put targets towards one end or the other of the
% % LongMaskerNoise. This is the proportion of time that the 'extra' masker
% % duration is put at the start of the trial
% p.addParameter('preSilence', 0, @isnumeric);
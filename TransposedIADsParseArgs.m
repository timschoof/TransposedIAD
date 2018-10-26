function sArgs=TransposedIADsParseArgs(ListenerName,varargin)
% get arguments for TransposedITD & ILD

%% Bharadwaj 2015 J Neurosci
% A half-wave rectified sinusoid at 40 Hz was used to modulate a 4 kHz carrier
% 40 Hz = 25 ms period - 75 dB SPL overall
% ITDs = {50, 100, 200, 400, 800} us and 1200 for poor listeners
% expressed in dB re 100 us = -6, 0, 6, 12, 18, 21.5 dB
% Presented in notched noise (800 Hz wide notch, so 3600-4400 Hz)
% bands of noise above (up to 10 kHz) and below (down to 20 Hz)
% served as maskers to reduce off-frequency cues at +10 dB (=65 dB SPL)
% masker BW = (3600-20) + (10000-4400) = 9180 Hz : 10*log10(9180)= 39.6
% Spectrum level = 65 - 39.6 = 25.4 dB SPL
%
% Dreyer & Oxenham (2008) used more or less the same notched noise, with
% the following average spectrum levels
% Stimulus level  noise spectrum level
% 40  50   60   70
% 3.1 11.3 19.5 27.7
% Plus an extra low-pass background noise (0–400 Hz)

% Target: 500 Hz band of noise centered at 4 kHz and modulated at 19 Hz.
% Unmodulated bands of noise above (up to 10 kHz) and below (down to 20 Hz)
% served as maskers to reduce off-frequency cues.
% The target to notched-noise ratio was 10 dB, and the overall level was 80
% dB SPL [broadband root mean square (RMS)].
% Diotic presentation
% Assuming flat spectra:
%   target=79.6 dB SPL
%   background=69.6 dB SPL
%   target=52.6 dB SPL/Hz
%   background=29.8 dB SPL/Hz


p = inputParser;
p.addRequired('ListenerName', @ischar);

% p.addParameter('SAMnoiseBandWidth', 500, @isnumeric); % always centred on the probe
% p.addParameter('TargetCentreFreq', 4000, @isnumeric);
p.addParameter('ModulationRate', 125, @isnumeric);
p.addParameter('ModulationPhase', -3*pi/2, @isnumeric);
p.addParameter('IAD', 'ITD',  @(x)any(strcmpi(x,{'ITD','ILD'})));
% Inter Aural Difference
p.addParameter('SignalDuration', 400, @isnumeric);
p.addParameter('NoiseDuration', 500, @isnumeric);
% the duration of the masker pulse. If longer than the target, the target is
% centred in it. Only relevant if LongMaskerNoise=0
p.addParameter('LongMaskerNoise', 1600, @isnumeric);
% if 0, masker noise is pulsed along with target intervals
% if >0 = continuous through triple at given duration (ms)
p.addParameter('propLongMaskerPreTarget', 0.9, @isnumeric);
% a parameter to put targets towards one end or the other of the
% LongMaskerNoise. This is the proportion of time that the 'extra' masker
% duration is put at the start of the trial
p.addParameter('preSilence', 0, @isnumeric);
% an interval of silence prepended to the wave to try to avoid sound glitches in Windows
p.addParameter('TranspositionFreq', 4000, @isnumeric);
p.addParameter('TranspositionLoPassCutoff', 1500, @isnumeric);
p.addParameter('TranspositionSmoothingFilterOrder', 4, @isnumeric);  

%p.addParameter('RMEslider', 'FALSE', @ischar); % adjust RME slider from MATLAB? TRUE or FALSE
p.addParameter('RMEslider', 'TRUE', @ischar); % adjust RME slider from MATLAB? TRUE or FALSE
p.addParameter('usePlayrec', 1, @isnumeric); % are you using playrec? yes = 1, no = 0
p.addParameter('VolumeSettingsFile', 'VolumeSettings4kHz.txt', @ischar);
p.addParameter('rms2use', 0.15, @isnumeric); % for the target
p.addParameter('RiseFall', 50, @isnumeric);
p.addParameter('ISI', 400, @isnumeric);
p.addParameter('SampFreq', 44100, @isnumeric);
p.addParameter('dBSPL', 80, @isnumeric);
% the nominal level of the fixed signal or noise - not yet used

%% parameters concerned with tracking and the task
% p.addParameter('inQuiet',0, @isnumeric);
% present tones in quiet in order to find absolute threshold without the
% masker present. Only makes sense for fixed masker
p.addParameter('LeadingEar', 'R',  @(x)any(strcmpi(x,{'L','R'})));
p.addParameter('MaximalDifference', 1, @isnumeric);
% if MaximalDifference=0, standards have ITD=0
% if MaximalDifference=1, standards have ITD the same as the odd one out,
%       but with the ears flipped
p.addParameter('starting_SNR',20, @isnumeric); % 18.0618 = 800 us
p.addParameter('START_change_dB', 4, @isnumeric);
p.addParameter('MIN_change_dB', 1, @isnumeric);
p.addParameter('LevittsK', 3, @isnumeric);
p.addParameter('INITIAL_TURNS', 3, @isnumeric);
p.addParameter('FINAL_TURNS', 4, @isnumeric);
p.addParameter('InitialDescentMinimum', -8, @isnumeric);
p.addParameter('TaskFormat', '2I-2AFC', @(x)any(strcmpi(x,{'3I-3AFC','3I-2AFC','2I-2AFC'})));
p.addParameter('Order', 2, @isnumeric);
% For 3I-3AFC, specifies the odd one out is given by 'LeadingEar'
% For 2I-2AFC, order specifies which direction of sound as given by 'LeadingEar'
p.addParameter('FeedBack', 'Corrective', @ischar);
p.addParameter('MAX_TRIALS', 30, @isnumeric);
p.addParameter('FacePixDir', 'Bears', @ischar);
p.addParameter('GoButton', 1, @isnumeric);
%% parameters concerned with background noise
p.addParameter('BackNzLevel',-2, @isnumeric); % in dB re target level
p.addParameter('LoBackNzLoPass',3600, @isnumeric);
p.addParameter('LoBackNzHiPass',20, @isnumeric);
%p.addParameter('HiBackNzLevel',0, @isnumeric); % in absolute rms
p.addParameter('HiBackNzLoPass',10000, @isnumeric);
p.addParameter('HiBackNzHiPass',4400, @isnumeric);
% p.addParameter('BackNzPulsed',0, @isnumeric); % 0 = continuous through triple
%% parameters concerned with debugging
p.addParameter('PlotTrackFile', 1, @isnumeric); % once test is finished
p.addParameter('DEBUG', 0, @isnumeric);
p.addParameter('outputAllWavs', 0, @isnumeric); % for debugging purposes
<<<<<<< HEAD
p.addParameter('MAX_SNR_dB', 16.9, @isnumeric); % maximal difference
=======
<<<<<<< HEAD
p.addParameter('MAX_SNR_dB', 16.9, @isnumeric); % maximal difference
=======
p.addParameter('MAX_SNR_dB', 22, @isnumeric); % maximal difference
>>>>>>> ad276f63ee08f99811591a7487863efae64ffefc
>>>>>>> c9954713f7f0da839c28bc68d06e15c05c1211d9
p.addParameter('MIN_SNR_dB', 0.25, @isnumeric); % minimal difference: for ILD only
p.addParameter('IgnoreTrials', 3, @isnumeric); % number of initial trials to ignore errors on
p.addParameter('OutputDir','results', @ischar);
p.addParameter('StartMessage', 'none', @ischar);
p.addParameter('MaxBumps', 3, @isnumeric);
% p.addParamValue('PresentInQuiet', 0, @(x)x==0 || x==1);

%% parameters concerned with tracking the absolute threshold of the stimuli
%  with a given modulation depth
p.addParameter('trackAbsThreshold', 0, @isnumeric);
p.addParameter('ITDAbsThreshold', -99, @isnumeric);

p.parse(ListenerName, varargin{:});
sArgs=p.Results;
sArgs.SNR_dB = sArgs.starting_SNR; % current level


% if masker is used, set the proper rms level & calculate relative spectrum level of it
sArgs.rms2useBackNz = sArgs.rms2use * 10^(sArgs.BackNzLevel/20); % rms level of background noise
MaskerBandwidth = (sArgs.LoBackNzLoPass - sArgs.LoBackNzHiPass) + (sArgs.HiBackNzLoPass - sArgs.HiBackNzHiPass);
sArgs.masker_dBperHz = sArgs.dBSPL-10*log10(MaskerBandwidth)+sArgs.BackNzLevel;
    
%backgroundNz_dBperHz = 20*log10(sArgs.dBSPL)-10*log10(MaskerBandwidth);
%sArgs.BackNzdB_re_Msk =  backgroundNz_dBperHz-masker_dBperHz;
%fprintf('BackNzdB_re_Msk= %3.1f\n', sArgs.BackNzdB_re_Msk);

% calculate initialDelay, the time before the 1st signal interval can occur
if sArgs.LongMaskerNoise<=0 % if maskers are pulsed
    % error('pulsed background noises not implemented');
    %% Insist that the duration of the noise is at least as long as the signal
    if sArgs.SignalDuration > sArgs.NoiseDuration
        error('Background noise pulse must be longer than the signal: Nz=%d Sig=%d', ...
            sArgs.NoiseDuration,sArgs.SignalDuration);
    end
    sArgs.initialDelay = (sArgs.NoiseDuration-sArgs.SignalDuration)/2;
else
    sArgs.initialDelay = sArgs.propLongMaskerPreTarget*(sArgs.LongMaskerNoise - (3*sArgs.SignalDuration+2*sArgs.ISI));
end
sArgs.initialDelay = sArgs.initialDelay + sArgs.preSilence;

if sArgs.TranspositionFreq>0
% lowpass filter for forwards/backwards
[sArgs.blo,sArgs.alo]=butter(sArgs.TranspositionSmoothingFilterOrder/2, ...
    ButterLoPassTweak(-1.5, sArgs.TranspositionLoPassCutoff, sArgs.TranspositionSmoothingFilterOrder/2)/(sArgs.SampFreq/2));
else
    sArgs.blo=0;sArgs.alo=0;
end

%% Get audio device ID based on the USB name of the device.
if sArgs.usePlayrec == 1 % if you're using playrec
    dev = playrec('getDevices');
    d = find( cellfun(@(x)isequal(x,'ASIO Fireface USB'),{dev.name}) ); % find device of interest - RME FireFace channels 3+4
    sArgs.playDeviceInd = dev(d).deviceID; 
    sArgs.recDeviceInd = dev(d).deviceID;
end

%% Read in feedback faces
sArgs=readFaces(sArgs);





function [response,p] = PlayAndReturnResponse2I2AFC(Wave2Play,trial,p)
%
% based on PlayAndReturnResponse3I3AFC - August 2018

% OneSoundDuration=max(p.NoiseDuration,p.ToneDuration); % for pulsed
% background noise
OneSoundDuration=max(p.SignalDuration);
if trial==1
    p.responseGUI = ResponsePad2I2AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,0);
    pause(0.5);
end

% intialize playrec if necessary
if p.usePlayrec == 1 % if you're using playrec
    if playrec('isInitialised')
        playrec('reset');
    end
    playrec('init', p.SampFreq, p.playDeviceInd, p.recDeviceInd);
    playrec('play', Wave2Play, [3,4]);
else
    playEm = audioplayer(Wave2Play,p.SampFreq);
    play(playEm);
end

% don't need these because the question asked the listener concerns
% direction from sound1 to sound 2
% IntervalIndicators(p.responseGUI, OneSoundDuration,p.ISI,p.initialDelay)
response = ResponsePad2I2AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,trial);



return
trial=2;
playEm = audioplayer(Wave2Play,SampFreq);
play(playEm);
IntervalIndicators(responseGUI, OneSoundDuration,ISI)
response = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial)


return


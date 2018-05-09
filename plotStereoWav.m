function plotStereoWav(varargin)

if nargin==0
    [wavFile,path] = uigetfile('*.wav');
else
    wavFile=char(varargin{1});
    path=[];
end
if ~exist(wavFile, 'file')
    [wavFile,path] = uigetfile('*.wav');
end
[y, SampFreq]=audioread(fullfile(path,wavFile));
disp(wavFile)
t=(0:length(y)-1)/SampFreq;
plot(t,y), legend({'L', 'R'})



[file,path] = uigetfile('0-wavsOut\*.wav');
[y, SampFreq]=audioread(fullfile(path,file));
disp(file)
t=(0:length(y)-1)/SampFreq;
plot(t,y)


function y = dBrms(s)
% this version works for aribitrary number of channels,
% but assumes waves go down the columns
y = 20*log10(norm(s(:,1))/sqrt((1/2)*length(s(:,1))));

%% Is it stereo? -- if so, calculate rms for other channel
n=size(s);
for k=2:n(2)
    y = [y  20*log10(norm(s(:,k))/sqrt((1/2)*length(s(:,k))))];
end
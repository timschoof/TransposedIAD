function plotHandle = plotTrackFile(fileName, labelString)

% Version 2.0 - September 2018
% return graphics file handle
% minSNR=-20;
% maxSNR=25;

if nargin<2
    labelString=[];
end

% clear
% fileName='results for real\SR_500HzS-S00-070rms-FixNz-3P_14-Mar-2018_17-59-56.csv';
d=robustcsvread(fileName);

nTrials=size(d,1)-1;

% d(1,:) % contains the headers

iTrial = find(strcmp([d(1,:)], 'trial'));
iSNR = find(strcmp([d(1,:)], 'IAD'));
iCorrect = find(strcmp([d(1,:)], 'correct'));

trial=[]; SNR=[]; correct=[]; response=[]; order=[];
for c=2:nTrials+1
    trial=[trial str2double(d{c,iTrial})];
    SNR=[SNR str2double(d{c,iSNR})];
    correct=[correct str2double(d{c,iCorrect})];
    %     response=[response str2double(conditions{c,5})];
    %     order=[order str2double(conditions{c,6})];
end

if length(trial)>5
    plotHandle = plot(trial, SNR, '-k');
    hold on
    plot(trial(correct==0), SNR(correct==0), 'ro')
    plot(trial(correct==1), SNR(correct==1), 'go')
    % ylim([minSNR maxSNR]);
    title(strrep(labelString,'_','-'))
    saveas(gcf,['',fileName,'.jpg',''])
    pause(1.5)
    close(gcf)
end



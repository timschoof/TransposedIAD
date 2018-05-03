function [w, wInQuiet, wUntransposed]=GenerateIADtriple(p)
%
%
ISIsamples=samplify(p.ISI,p.SampFreq);
ISIwave=zeros(ISIsamples,2);

w=[]; % the actual trial stimulus
wInQuiet=[]; % contains the stimuli without background noise
wUntransposed=[];
if p.LongMaskerNoise<=0
    error('not yet implemented for pulsed masker noises');
%     % calculate the necessary offsets to make the target pulse the same
%     % duration as the masker
%     BackNzSamples=samplify(p.NoiseDuration,p.SampFreq);
%     TargetSamples=samplify(p.SignalDuration,p.SampFreq);
%     pre = zeros(ceil((BackNzSamples-TargetSamples)/2),1);
%     post = zeros(BackNzSamples-(TargetSamples+length(pre)),1);
%     for i=1:3
%         % generate one signal
%         % function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
%         [AM, flatNz, mm]=GenerateSAMnz(p.Order==i, p);
%         if p.Order==i
%             modulator=mm;
%         end
%         % if tracking absolute thresholds, scale the modulated tone by the
%         % current SNR level. Otherwise, zero out the unmodulated noises
%         if p.trackAbsThreshold
%             if p.Order==i
%                 AM = AM * 10^(p.SNR_dB/20);
%             else
%                 AM=AM*0;
%             end
%         end
%         
%         % centre the AM pulse in the background noise
%         AM = vertcat(pre, AM, post);
%         AMnz = vertcat(AMnz, AM);
%         % generate a single pulse of background noise
%         backNz=GenerateBackgroundNoiseSAM(p);
%         w=vertcat(w, AM+backNz);
%         if i<3
%             w=vertcat(w,ISIwave);
%             AMnz=vertcat(AMnz,ISIwave);
%         end
%     end
else % long masker (actually background noise)
    % generate the signal pulses
    % construct the 3 intervals with ISIs
    for i=1:3
        if strcmp(p.IAD, 'ITD')
            % function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
            if p.MaximalDifference==0 % the typical case, perhaps
                [x, untransposed]=GenerateITDpulse(p.Order==i, p);
            else % give the listener the best chance
                currentLeadingEar = p.LeadingEar; % save the value
                if p.Order==i % the odd one out: leave ear as is
                    [x, untransposed]=GenerateITDpulse(1, p);
                else % swap the leading ear
                    if p.LeadingEar=='L'
                        p.LeadingEar='R';
                    else
                        p.LeadingEar='L';
                    end
                    [x, untransposed]=GenerateITDpulse(1, p);
                    p.LeadingEar= currentLeadingEar;
                end
            end
        else % manipulate ILD
            % function [w, untransposed]=GenerateITDpulse(ITDpresent, p)
            if p.MaximalDifference==0 % the typical case, perhaps
                [x, untransposed]=GenerateILDpulse(p.Order==i, p);
            else % give the listener the best chance
                currentLeadingEar = p.LeadingEar; % save the value
                if p.Order==i % the odd one out: leave ear as is
                    [x, untransposed]=GenerateILDpulse(1, p);
                else % swap the leading ear
                    if p.LeadingEar=='L'
                        p.LeadingEar='R';
                    else
                        p.LeadingEar='L';
                    end
                    [x, untransposed]=GenerateILDpulse(1, p);
                    p.LeadingEar= currentLeadingEar;
                end
            end            
        end
        % if tracking absolute thresholds, scale the modulated tone by the
        % current SNR level. Otherwise, zero out the unmodulated noises
        %% !! not thought about yet!!
        if p.trackAbsThreshold
            if p.Order==i
                AM = AM * 10^(p.SNR_dB/20);
            else
                AM=AM*0;
            end
        end
        
        wInQuiet=vertcat(wInQuiet, x);
        wUntransposed=vertcat(wUntransposed, untransposed);
        if i<3
            wInQuiet=vertcat(wInQuiet,ISIwave);
            wUntransposed=vertcat(wUntransposed,ISIwave);
        end
    end
    w =wInQuiet;
    %% generate and add in background noise when it is long,
    %  i.e., played through the triple
    %  for the moment, generate silence of the appropriate length
        if ~ p.trackAbsThreshold
            if p.rms2useBackNz > 0
                % w=GenerateBackgroundNoiseSAM(p);
                % centre targets in background noise
                Nz=zeros(samplify(p.LongMaskerNoise,p.SampFreq),2);
                xtra = length(Nz)-length(w);
                xtraFront = ceil(p.propLongMaskerPreTarget*xtra);
                if xtra>0
                    w=vertcat(zeros(xtraFront,2),w, zeros(xtra-xtraFront,2));
                end
                w = w + Nz;
            else
                % w =wInQuiet;
            end
        else % if tracking absolute threshold
    %         if p.rms2useBackNz > 0
    %             w=GenerateBackgroundNoiseSAM(p);
    %             % scale background noise
    %             w = w * 10^(p.SNR_dB/20);
    %             % centre targets in background noise
    %             xtra = length(w)-length(AMnz);
    %             xtraFront = ceil(p.propLongMaskerPreTarget*xtra);
    %             if xtra>0
    %                 AMnz=vertcat(zeros(xtraFront,1),AMnz, zeros(xtra-xtraFront,1));
    %             end
    %             w = w + AMnz;
    %         else
    %             w = AMnz;
    %         end
        end
    
end

% prepend silence to wave if necessary
w = vertcat(zeros(p.SampFreq*p.preSilence/1000,2),w);
wInQuiet = vertcat(zeros(p.SampFreq*p.preSilence/1000,2),wInQuiet);
wUntransposed = vertcat(zeros(p.SampFreq*p.preSilence/1000,2),wUntransposed);








function [short long t]= aggregateReversals(directory)
% [short long t]= aggregateReversals(directory) 
%
% Go through a directory containing .mat files that were exported during
% reversal analysis from the preview_w_YAML file and aggregate 
% them into one data set that has reversal magnitude and time of stimulus
% 
% Then output the aggregated data in a mat file in the parent directory.
%
% This script is designed to analyze the data of a single run.. e.g. a
% contiguous set of recordings on one worm. 
%
% Other scripts like aggregateWorms.m are designed to aggregate runs from
% many different worms that all underwent the same experiment.
% 
disp('Welcome.');
files=ls([directory '\*.mat']);


steps = size(files,1);

if steps==0
    disp('No files found!')
    short=[]
    long=[]
    t=[]
    return
end
wait = waitbar(0,'Aggregating reversals...');
protocol=[];
for k=1:steps
    
    waitbar(k/ steps)

    
    disp(['Loading ' files(k,:) ' ...' ]);
    

    
    %Load the file
    load( [directory '\'  files(k,:)],'-mat')
    disp('loaded!');
    

    
    
    %Check to make sure we are dealing with a mat file that was generated
    %from the mindcontrol preview program   
    
    if ( ~exist('expTimeStamp') || ~exist('handles')|| ~exist('phaseVelocity')|| ~exist('T1') )
        disp([directory '\'  files(k,:) '  does not seem to be a valid preview_wYAML_v9 export file!']  )
        continue
    end
    %record the start of each recording in this series
    N_recordingStartTime(k)=expTimeStamp;
    
    %Calculate the time of stimulus in seconds since beginning of this
    %recording (in seconds)
    s_time=handles.sElapsed_data+(10^-3)*handles.msRemElapsed_data;
    
    
    
    %calculate the actual time of this stimulation according to the
    %computers clock (in matlab's serialized datenum format)
    N_realTime(k)=datenum( datevec(expTimeStamp)+[0 0 0 0 0 s_time(T2-T1)]);
    
    
    %Santiy check...
    %Occasionally I get spurious stimuli that claim to be from 10000
    %seconds out. To make this traceable, I now print the timestamp
        
    disp(['Adding stimulus at ' datestr(N_realTime(k))])
        
    
    
 
    
    
    %On rare occasions it is important to manually correct the computers's
    %error. One such occasion would be if there was a clear reversal, but the computer
    %flipped the head and tail at the last moment and thus scored the event
    %as a non-reversal. Normally this point would be tossed out. But if
    %this happens to be the first stimulus in a trial, than it is important
    %that this point remains, because it is used as the start time for the
    %entire trial. In that case the experimenter goes in by hand and scores
    %the event as a a reversal or not. Note as of the submission of this manuscript, this manual
    %scoring was used in exactly one instance.
    if (exist('specialManualDataPointFlag')&& exist('manual_short_reversal_score')&& exist('manual_long_reversal_score') )
        %read in the manually set data point
        short(k)=manual_short_reversal_score;
        long(k)=manual_long_reversal_score;
        clear specialManualDataPointFlag;
        clear manual_short_reversal_score;
        clear manual_long_reversal_score;
    else
    
        %Compute short and long reversal response as usual
        [short(k) long(k)]=computeReversalResponse(phaseVelocity,s_time,T2-T1,T3-T1,[],0);
    end

    %Save the HUDS frame number of the start of illumination
    try
    frame_HUDS(k)=handles.CamFrameNumber(T2-T1);
    catch err2
        disp('Error! CamFrameNumber(T2-T1)')
    end
    
    %Save information about what protocol step was used to deliver the
    %stimulus
    try
        if ~isempty(handles.ProtocolStep_data)
            protocol(k)=round(mean(handles.ProtocolStep_data(T2-T1:T3-T1)));
        end
    end
    
    
	clear('handles','phaseVelocity','time','T1','T2','T3','T4','expTimeStamp');
end


%There are often more then one contiguous recordings per experiment.
N_firstRecording=min(N_recordingStartTime);

%Calculate the time t in secondes elapsed since the beginning of the first
%recording for this experiment 
for k=1:length(N_realTime)
    t(k)= etime(datevec(N_realTime(k)),datevec(N_firstRecording));
end


%convert frame_HUDS into a cell area of strings for graphing purposes
for k=1:length(frame_HUDS)
%     if ischar(frame_HUDS(k))
%         str=num2str(frame_HUDS(k));
%     else
%         str='Error';
%     end
    frame_HUDS_str{k}=num2str(frame_HUDS(k));
end
try
disp(['Writing to ' directory '_aggregate.mat']);
save([directory '_aggregate.mat'],'frame_HUDS', 'protocol','frame_HUDS_str','t','N_firstRecording','short','long','N_realTime','N_recordingStartTime');
catch err1
    disp('Error! could not write out!');
end

figure;

hold on;
plot(t,short,'o');
plot(t,zeros(length(t),1),'-.');
title('Short-Term Response'); xlabel('Time (s)');ylabel('mean phase velocity above baseline')
text(t,ones(1,length(t)).*(min(short)-1), frame_HUDS_str);


figure;
plot(t,long,'o');
title('Long-Term Response');xlabel('Time (s)');ylabel('mean phase velocity above baseline')
text(t,ones(1,length(t)).*(min(short)-1), frame_HUDS_str);

if exist('wait')
    close(wait)
end



if exist('err1') 
    rethrow(err1)
else
    disp('Goodbye.');
end

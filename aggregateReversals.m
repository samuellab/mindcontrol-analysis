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
files=ls([directory '\*.mat']);

h = waitbar(0,'Aggregating reversals...');
steps = size(files,1);



for k=1:steps
    
    waitbar(k/ steps)

    
    disp(files(k,:));
    

    
    %Load the file
    load( [directory '\'  files(k,:)],'-mat')
    
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
    
    %Compute short and long reversal response
    [short(k) long(k)]=computeReversalResponse(phaseVelocity,s_time,T2-T1,T3-T1,[],0);
    

    %Save the HUDS frame number of the start of illumination
    frame_HUDS(k)=handles.CamFrameNumber(T2-T1);
    
    
	clear('handles','phaseVelocity','time','T1','T2','T3','T4','expTimeStamp');
end

close(h)

%There are often more then one contiguous recordings per experiment.
N_firstRecording=min(N_recordingStartTime);

%Calculate the time t in secondes elapsed since the beginning of the first
%recording for this experiment 
for k=1:length(N_realTime)
    t(k)= etime(datevec(N_realTime(k)),datevec(N_firstRecording));
end


%convert frame_HUDS into a cell area of strings for graphing purposes
for k=1:length(frame_HUDS)
    frame_HUDS_str{k}=num2str(frame_HUDS(k));
end
try
save([directory '_aggregate.mat'],'frame_HUDS', 'frame_HUDS_str','t','N_firstRecording','short','long','N_realTime','N_recordingStartTime');
catch err1
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
if exist('err1') 
    rethrow(err1)
else
    disp('Goodbye.');
end

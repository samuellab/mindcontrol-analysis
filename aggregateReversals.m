function [short long t]= aggregateReversals(directory)
% [short long t]= aggregateReversals(directory) 
%
% Go through a directory containing .mat files that were exported during
% reversal analysis and aggregate them to make a graph of the habituation
% response.

files=ls([directory '\*.mat']);

for k=1:size(files,1)
    
    
    disp(files(k,:));
    

    
    %Load the file
    load( [directory '\'  files(k,:)],'-mat')
    
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
    
    %Compute naive lazy reversals
    [extremas_short(k,:), extremas_long(k,:)] = computeLazyReversalResponse(phaseVelocity,s_time,T2-T1,T3-T1,[],0);
   
    %Save the HUDS frame number of the start of illumination
    frame_HUDS(k)=handles.CamFrameNumber(T2-T1);
    
    
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
    frame_HUDS_str{k}=num2str(frame_HUDS(k));
end

save([directory '\aggregate_data.mat'],'frame_HUDS', 'frame_HUDS_str','t','N_firstRecording','short','long','extremas_short','extremas_long','N_realTime','N_recordingStartTime');


figure;
subplot(2,1,1);
hold on;
plot(t,short,'o');
plot(t,zeros(length(t),1),'-.');
title('Short-Term Response'); xlabel('Time (s)');ylabel('mean phase velocity above baseline')
text(t,ones(1,length(t)).*(min(short)-1), frame_HUDS_str);
subplot(2,1,2);
plot(t,extremas_short(:,1),'^');


figure;
plot(t,long,'o');
title('Long-Term Response');xlabel('Time (s)');ylabel('mean phase velocity above baseline')
text(t,ones(1,length(t)).*(min(short)-1), frame_HUDS_str);

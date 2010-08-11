function [r_short r_long] = computeReversalResponse(phaseVelocity,timeIndex,f_startIllum,f_endIllum,t_analWin,DEBUG)
% This function computes the Reversal response of a worm after it was
% illuminated.
%
% Here reversal respons is defined as average velocity above baseline
% during window. 
%
% phaseVelocity frame-by-frame phase velocities in wormlengths / second
% timeIndex is a vector containing timestamps corresponding to each frame
% startIllum is the frame at which the illumination begins
% f_endIllum is the frame at which illumination ends
% analysisWindow is a structure that sets the expected window time
%     t_analWin.beforeIllum   seconds to analyze before illumination
%     t_analWin.short seconds to analyze post illum for the short window
%     t_analWin.long  seconds to analyze after the short window for the
%     long window
%
% Note: phaseVelocity should have N-1 elements, timeIndex has N elements
%
%
% This metric captures the range of behaviours I am interested ni:
% If the worm starts paused and then reverses, the response is negative.
% If the worm moves forwards and then pauses, the response is negative.
% If the worm is entirely still, the response is zero.
% If the worm speeds up, the response is positive. 
% If the worm is reversing but slows its reversla, the response is
% positive.
%
% by Andrew Leifer
% 16 July 2010
% leifer@fas.harvard.edu
if isempty(DEBUG)
    DEBUG=true;
end

if isempty(t_analWin)
    %applying default value for analysis windonw t_analWin
    t_analWin.beforeIllum=2; %2 seconds prior to a illum
    t_analWin.short=1.5; %1.5 seconds post illumination (so 3.5 seconds total)
    t_analWin.long=5.5; %6.5 secondps after the short window
end

%First let's do some sanity checks
if( length(phaseVelocity) ~= length(timeIndex)-1 )
    error('The length of phaseVelocity and timeIndex do not match!');
end

if( f_startIllum >length(timeIndex) || f_endIllum > length(timeIndex))
    error('f_startIllum or f_endIllum fall outside of the time series data provided');
end

if (f_startIllum >f_endIllum)
    error('Doh. f_startIllum should be before f_endIllum.');
end

%check that our data is at least as long as our analysis
%windows
   
if  ( floor( t_analWin.beforeIllum+t_analWin.short+t_analWin.long+ ...
        ( timeIndex(f_endIllum) - timeIndex(f_startIllum) )  ) > timeIndex(end)-timeIndex(1) )
    disp('Data provided is shorter than the analysis window time and specified illumination time. \nIn other words yoru timing does not add up.');
    disp('continuing onward anyway with a much shorter long-analysis window time of 1 seconds');
    t_analWin.long=1;
    
end

%time that analysis begins
t_startanal=timeIndex(f_startIllum)-t_analWin.beforeIllum;


%time that analysis ends
t_endanal=timeIndex(f_endIllum)+t_analWin.short+t_analWin.long;


%Frame that analysis begins/ ends
f_start_anal=findClosest( timeIndex, t_startanal);
f_end_anal=findClosest(timeIndex,t_endanal);


% Compute the average phase velocity prior to illumination
v0=mean(phaseVelocity(f_start_anal:f_startIllum));
devFromv0=phaseVelocity-v0;


%%%%%%
% Short Response Analysis
%%%%%%
% start times and frames of short analsyis
f_short_start=f_startIllum;
t_short_start=timeIndex(f_short_start);

%end times and frames of short analysis
t_short_end= timeIndex(f_endIllum)+t_analWin.short;
f_short_end=findClosest(timeIndex,t_short_end);


%duration
d_short=t_short_end-t_short_start;

%response (units of bodylength/sec/sec) accelleration.. makes sense
r_short=sum(devFromv0(f_short_start:f_short_end))./d_short; 



%%%%%%
% Long Response Analysis
%%%%%%
%start times
t_long_start=t_short_end;
f_long_start=f_short_end;

%end times
f_long_end=f_end_anal;
t_long_end=t_endanal;

%duration
d_long=t_long_end-t_long_start;

%response
r_long= sum(devFromv0(f_long_start:f_long_end-1))./d_long;





if DEBUG

    
    figure; 
    subplot(2,1,1);hold on; 
    plot(phaseVelocity); title(['Illumination at' num2str(timeIndex(f_startIllum)) 'seconds, R_s=' num2str(r_short) ' R_l=' num2str(r_long)]);plot([f_startIllum, f_endIllum],[0,0],'ro'); 
    plot([f_start_anal, f_end_anal],[0,0],'k-');
    
    %plot markers showing end of short analysis and long analysis
    plot([f_short_end, f_long_end],[v0,v0],'g^');
    plot([f_start_anal, f_end_anal],[v0,v0],'k-.');
    ylabel('phase velocity (bodylengths/second)')
    subplot(2,1,2);hold on; 
    plot([f_start_anal:f_short_start-1],cumsum(devFromv0(f_start_anal:f_short_start-1)),'r');
    plot([f_short_start:f_short_end-1],cumsum(devFromv0(f_short_start:f_short_end-1)),'g');
    plot([f_long_start:f_long_end-1],cumsum(devFromv0(f_long_start:f_long_end-1)),'b');
    ylabel('Distance Traveled In Each Window Beyond Baseline')
    xlabel('Frame')
end

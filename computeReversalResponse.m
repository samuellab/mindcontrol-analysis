function [rshort rlong] = computeReversalResponse(phaseVelocity,timeIndex,f_startIllum,f_endIllum,t_analWin)
% This function computes the Reversal response of a worm after it was
% illuminated.
%
% phaseVelocity frame-by-frame phase velocities in wormlengths / second
% timeIndex is a vector containing timestamps corresponding to each frame
% startIllum is the frame at which the illumination begins
% f_endIllum is the frame at which illumination ends
% analysisWindow is a structure that sets the expected window time
%     analysisWindow.beforeIllum   seconds to analyze before
%           illumination
%     analysisWindow.short
%     analysisWindow.long
%
% Note: phaseVelocity should have N-1 elements, timeIndex has N elements
%
% The reversal response is computed according to a "distance-not-traveled
% per second" model. The worm's average phase velocity is computed prior 
% to the f_startIllum frame. Then the integrated distance the worm traveled
% (computed from the phase velocity) is subtracted from the distance the
% worm would have traveled at its initial velocity. 
% 
% This value is normalized by the amount of time elapsed.
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

DEBUG=true;

if isempty(t_analWin)
    %applying default value for analysis windonw t_analWin
    t_analWin.beforeIllum=2; %2 seconds prior to a illum
    t_analWin.short=1.5; %1.5 seconds post illumination
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
    error('Data provided is shorter than the analysis window time and specified illumination time.');
    error('In other words yoru timing does not add up.');
end

%time that analysis begins
t_startanal=timeIndex(f_startIllum)-t_analWin.beforeIllum;

if (t_startanal<0)
    error('Not enough lead time before the illumination begins.')
end

% Compute the average phase velocity prior to illumination
f_start_anal=findClosest( timeIndex, t_startanal);
v0=mean(phaseVelocity(f_start_anal:f_startIllum));

%%%%%%
% Short Response Analysis
%%%%%%

%Duration of the short analysis is from the start of illumination to t_analWin.short seconds
%after the end of illumiantion
d_short= ( timeIndex(f_endIllum) -timeIndex(f_startIllum) )  +t_analWin.short; %duration of short analysis
expectDist_short=v0*d_short;
f_end_short= findClosest(timeIndex, timeIndex(f_startIllum)+d_short); %frame that ends the short analysis


%compute the actual distance by doing an integration... take the dot
%product of the instantaneous phase velocity and the time
%interval... think about it.. it works
actualDist_short = ...
    dot(phaseVelocity(f_startIllum:  f_end_short-1), timeIndex(f_startIllum:f_end_short-1)-timeIndex(f_startIllum+1:f_end_short) );

rshort=  ( expectDist_short - actualDist_short ) /d_short;

%%%%%%
% Long Response Analysis
%%%%%%


d_long= t_analWin.long; %duartion of long analysis
expectDist_long=v0*d_long;
f_end_long= findClosest(timeIndex, timeIndex(f_startIllum)+d_short+d_long); %frame that ends the long analysis
actualDist_long = ...
    dot(phaseVelocity(f_end_short:  f_end_long-1), timeIndex(f_end_short:f_end_long-1)-timeIndex(f_end_short+1:f_end_long) );
rlong=  ( expectDist_long - actualDist_long ) /d_long;


if DEBUG

    
    figure; 
    subplot(2,1,1);hold on; 
    plot(phaseVelocity); title(['R_s=' num2str(rshort) ' R_l=' num2str(rlong)]);plot([f_startIllum, f_endIllum],[0,0],'ro'); 
    plot([f_start_anal, f_end_long],[0,0],'k-');
    
    %plot markers showing end of short analysis and long analysis
    plot([f_end_short, f_end_long],[v0,v0],'g^');
    plot([f_start_anal, f_end_long],[v0,v0],'k-.');
    subplot(2,1,2);hold on; 
    plot(cumsum(phaseVelocity-v0));
end

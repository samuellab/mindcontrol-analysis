%  Copyright 2010 Andrew Leifer et al <leifer@fas.harvard.edu>
%  This file is part of Mindcontrol-analysis.
% 
%  Mindcontrol-analysis is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  Mindcontrol-analysis is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with mindcontrol-analysis. If not, see <http://www.gnu.org/licenses/>.


function [extremas_short, extremas_long] = computeLazyReversalResponse(phaseVelocity,timeIndex,f_startIllum,f_endIllum,t_analWin,DEBUG)
% This function computes the Reversal response of a worm after it was
% illuminated using a naive lazy method. 
%
% This function just returns the max and min in different time intervals of
% the difference between phasevelocity and baseline phasevelocity.
%
% It doesn't seem to be a very good metric.
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
% by Andrew Leifer
% 16 July 2010
% leifer@fas.harvard.edu
%
%
%  For the most up to date version of this software, see:
%  https://github.com/samuellab/mindcontrol
% 
% NOTE: If you use any portion of this code in your research, kindly cite:
% Leifer, A.M., Fang-Yen, C., Gershow, M., Alkema, M., and Samuel A. D.T.,
%   "Optogenetic manipulation of neural activity with high spatial resolution
%   in freely moving Caenorhabditis elegans," Nature Methods, Submitted
%   (2010).
% 

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
    error('Data provided is shorter than the analysis window time and specified illumination time.');
    error('In other words yoru timing does not add up.');
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


minVelShort=min(devFromv0(f_short_start:f_short_end));
maxVelShort=max(devFromv0(f_short_start:f_short_end));

extremas_short=[minVelShort maxVelShort];

%%%%%%
% Long Response Analysis
%%%%%%
%start times
t_long_start=t_short_end;
f_long_start=f_short_end;

%end times
f_long_end=f_end_anal;
t_long_end=t_endanal;

maxVelLong=max(devFromv0(f_long_start:f_long_end));
minVelLong=min(devFromv0(f_long_start:f_long_end));

extremas_long= [minVelLong, maxVelLong];
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

function nu=velocityanalysis(handles)
% The mindcontrol previewer program reads in centerline data from a YAML file
% and passes that to this function which calculates a phase velocity and
% also optionally fits a that phase velocity to a hyperbolic tangent.
%
%
% For the most up to date version of this software, see:
% http://github.com/samuellab/mindcontrol
% 
% NOTE: If you use any portion of this code in your research, kindly cite:
% Leifer, A.M., Fang-Yen, C., Gershow, M., Alkema, M., and Samuel A. D.T.,
%   "Optogenetic manipulation of neural activity with high spatial resolution
%   in freely moving Caenorhabditis elegans," Nature Methods, Submitted
%   (2010).
% 

FIT2TANH=0;


curvdata=handles.curvdata;
 T1 = str2num(get(handles.edit_T1, 'String'));
T2 = str2num(get(handles.edit_T2, 'String'));
T3 = str2num(get(handles.edit_T3, 'String'));
tstamp=handles.sElapsed_data+handles.msRemElapsed_data./1000;
absFrameNumberStart=handles.frameindex(str2num(get(handles.edit_T1, 'String')),1);
absFrameNumberEnd=handles.frameindex(str2num(get(handles.edit_T4, 'String')),1);


%Find Phase Shift per frame: 
ps=findPhaseShift(curvdata);


%Seconds per frame
spf=(tstamp(end)-tstamp(1))/length(tstamp); %seconds per frame


%Find the velocity
% sigma=1;
% psFilt=lowpass1d(ps,sigma); 
psFilt=ps; %don't do any filtering on the velocity. we can do that later.


% convert from percent bodylength per frame to body length per second
nu= -psFilt ./ (100*spf);
%We would like to get that into fractional body length per second
%So we must multpily by (1/(100))*(1/ ( seconds /frame) );



%find corners using fit to tanh
if(FIT2TANH)
  [tanhCoef,tanhGOF, c1, c2]= findcorners(nu);
end

x=1:length(nu);
 
 
 
 %Plot Output:
 figure(3); clf; hold on;
if FIT2TANH
 A=tanhCoef.A;
 beta=tanhCoef.beta;
 x0=tanhCoef.x0;
 B=tanhCoef.B;
 y=A*tanh(beta.*(x-x0))+B;
end

 hold on;
 subplot(1,2,1)
 imagesc(curvdata*size(curvdata,2), [-10,10]);
 colormap(redbluecmap(1)); 
 title('Curvature')
 xlabel('<- Head     Tail->')
 ylims=get(gca,'Ylim');
 ylabel('Time (Rel Frame #)');
hold on;
if T2 > T1
    plot([0 size(curvdata,2)], [T2-T1 T2-T1], '--w');
end
if T3 > T1
    plot([0 size(curvdata,2)], [T3-T1 T3-T1], '--w');
end




 
 subplot(1,2,2)
 hold on;
 
 %Plot phase velocity
 plot(nu,x)

 if FIT2TANH
     %Plot the hyperbolic tangent fit
     plot(y,x,'m','linewidth',2)
     plot([A+B B-A],[x0+1/beta x0-1/beta],'ro','linewidth',3);
 end
 
set(gca,'YDir','reverse');
set(gca,'Ylim',ylims);
title('Phase velocity')
xlabel('body length / second')
if T2 > T1
    plot([min(nu) max(nu)], [T2-T1 T2-T1], '--r');
end
if T3 > T1
    plot([min(nu) max(nu)], [T3-T1 T3-T1], '--r');
end

plot([0 0],[0, length(nu)],'--b')


 set(gca,'Box','off');
axesPosition = get(gca,'Position');          %# Get the current axes position
hNewAxes = axes('Position',axesPosition,...  %# Place a new axes on top...
                'Color','none',...           %#   ... with no background color 
                'YLim',[ absFrameNumberStart,...
                absFrameNumberEnd],...            %#   ... and a different scale
                'YAxisLocation','right',...  %#   ... located on the right
                'XTick',[],...                  %#   ... and with no x tick marks
               'YDir','reverse',...
                'Box','off');                 %ylabel(hNewAxes,'hframe');  %# Add a label to the right y axis
ylabel('HUDS Frame number');
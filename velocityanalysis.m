
function nu=velocityanalysis(handles)
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

% pass the the phase shift through a 3-frame-wide median filter 
% psFilt=medfilt1(ps,3)


psFilt=ps; 


%%% Replace outliers with the median value for a large window
threshold=3; %Number of standard deviations away from local median to be called an outlier
medfiltwindow=30;

medianfiltered=medfilt1(ps,medfiltwindow);

%find outliers
outliers=find( abs(medianfiltered -psFilt)>std(psFilt)*threshold);
%replace outliers with median value
psFilt(outliers)=medianfiltered(outliers);

% convert from percent bodylength per frame to body length per second
nu= -psFilt ./ (100*spf);


%We would like to get that into fractional body length per second
%So we must multpily by (1/(100))*(1/ ( seconds /frame) );

[tanhCoef,tanhGOF, c1, c2]= findcorners(nu);
 x=1:length(nu);
 
 
 %Plot Output:
 figure(3); clf; hold on;
 A=tanhCoef.A;
 beta=tanhCoef.beta;
 x0=tanhCoef.x0;
 B=tanhCoef.B;
 y=A*tanh(beta.*(x-x0))+B;

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
 plot(nu,x)
 plot(y,x,'m','linewidth',2)
 plot([A+B B-A],[x0+1/beta x0-1/beta],'ro','linewidth',3);
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
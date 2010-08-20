function makeVelocityFigure(directory,illumRegion)

%Load a file exported from the YAML previewer software and display the
%kymograph and the phase velocity
%
% Andrew Leifer
% leifer@fas.harvard.edu
% 17 August 2010


%Load a file that was exported from the previewer software

load(directory);






%extract the timing data for the entire experiment
t=handles.time; %timestamp at each frame

%(recall that the raw data is in terms of frames, but for figures we often
%want to present the data in terms of time)

%plot the raw curvature data
figure(1); clf; 
imagesc(handles.curvdata,[-.1 .1]); hold on;
colormap(redbluecmap(1)); 

if exist('illumRegion','var')
    plot([illumRegion(1), illumRegion(1)], [T2-T1, T3-T1],'--w');
    plot([illumRegion(2), illumRegion(2)], [T2-T1, T3-T1],'--w');
    plot([illumRegion(1), illumRegion(2)], [T2-T1, T2-T1],'--w');
    plot([illumRegion(1), illumRegion(2)], [T3-T1, T3-T1],'--w');
end

axesPosition = get(gca,'Position');          %# Get the current axes position
axis off; %turn off current axis

hNewAxes = axes('Position',axesPosition,...  %# Place a new axes on top...
                'Color','none',...           %#   ... with no background color 
                'YLim',[t(T1)-t(T2), t(T4)-t(T2)],...            %#   ... and a different scale
                'YAxisLocation','left',...  %#   ... located on the right
                'XLim',[0 100],...                %#   
                'YDir','reverse');           %# flip directions
                %);            
  
ylabel(hNewAxes,'Time (s)');  %# Add a label to the right y axis
xlabel('<--Head            Tail-->');




%plot the phase veloceity

mn=min(phaseVelocity);
mx=max(phaseVelocity);
figure(2); clf; hold on; 
plot(t(T1:T4-1)-t(T2),phaseVelocity);
plot([0 0],[mn,mx],'--k');
plot([t(T3)-t(T2), t(T3)-t(T2)],[mn,mx],'--k');
plot([t(T1)-t(T2), t(T4)-t(T2)], [0 0],'k');

disp(['Frame rate is ' num2str( (T4-T1)/(t(T4)-t(T1)) ) ' fps.']);

ylabel('Phase Velocity (wormlength/s)')
xlabel('Time (s)')

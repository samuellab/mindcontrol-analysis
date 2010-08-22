function sliceKymograph(directory, slice, illumRegion, kymoSaturationLevel,velLim)
%sliceKymograph(directory, slice, illumRegion, kymoSaturationLevel,velLim)
%
%Load a file exported from the YAML previewer software and display the
%kymograph and chop into a bunch of slices along the worm's body lenght and
%display the curvature diagram for those body lenghts over time.
%
% Andrew Leifer
% leifer@fas.harvard.edu
% 17 August 2010


%Load a file that was exported from the previewer software
%load('D:\Analysis\myo3Halo_wavesupression\20091117_1804_zx444Halo_HUDS_12521-12792_if2171_2442.mat')
load(directory);

%Set the locations along the worm's body where one wants to take slices
if isempty(slice)
    disp('using default slice value');
    slice=[10 25 50 75 95];
end

% set the default kymograph saturation levels
if isempty(kymoSaturationLevel)
    disp('using default kymograph saturation levels');
    kymoSaturationLevel=[-.1 .1];
end

%set the default velocity limits
if isempty(velLim)
    disp('setting default velocity limit levels');
    velLim=[-1,1]
end

if isempty(illumRegion)
    illumRegion=[0 100];
end


%Specify the anterior-to-posterior illumination region.
% At the moment this has to be entered by hand, but its easy to find
% by manual inspection of the corresponding YAML file.

%illumRegion= [38, 60];



%extract the timing data for the entire experiment
t=handles.time; %timestamp at each frame
%(recall that the raw data is in terms of frames, but for figures we often
%want to present the data in terms of time)

%plot the raw curvature data
figure(1); clf; 
imagesc(handles.curvdata,kymoSaturationLevel); hold on;
colormap(redbluecmap(1)); 
if exist('illumRegion','var') && ~isempty(illumRegion)
    illumRegion(1)
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


%plot the slices
figure(2); clf; hold on; 
for k=1:length(slice)
    
    subplot(length(slice),1,k);
    hold on;
    
    curvSlice=handles.curvdata(:,slice(k));
    
    %plot(curvSlice);
    
    %plot with respect to time in seconds, such that zero is the time of
    %stimulus
    plot(t(T1:T4)-t(T2),curvSlice);
    ylim(velLim);
    
    ylabel([num2str(slice(k)) '%'])
    if (k==1); title('Curvature over time for different body segments'); end
    
    %Plot vertical dotted lines for the on/off DLP events
    plot([0, 0],[min(curvSlice) max(curvSlice)],'--k')
    plot([t(T3)-t(T2), t(T3)-t(T2)],[min(curvSlice) max(curvSlice)],'--k')

    clear curvSlice;

end
xlabel('Time (s)')
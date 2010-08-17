
%Load a file that was exported from the previewer software
load('D:\Analysis\myo3Halo_wavesupression\20091117_1804_zx444Halo_HUDS_12521-12792_if2171_2442.mat')

%Set the locations along the worm's body where one wants to take slices
slice=[10 20 50 60 80];

%plot the raw curvature data
figure(1); clf;
imagesc(handles.curvdata)

figure(2); clf; hold on; 


for k=1:length(slice)
    
    
    subplot(length(slice),1,k);
    hold on;
    
    curvSlice=handles.curvdata(:,slice(k));
    plot(curvSlice);
    
    
    ylabel([num2str(slice(k)) '%'])
    if (k==1); title('Curvature over time for different body segments'); end
    
    %Plot vertical dotted lines for the on/off DLP events
    plot([T2-T1, T2-T1],[min(curvSlice) max(curvSlice)],'--k')
    plot([T3-T1, T3-T1],[min(curvSlice) max(curvSlice)],'--k')
    clear curvSlice;

end
xlabel('Frames')
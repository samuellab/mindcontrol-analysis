

%For Halo Halo Figure
load('D:\Analysis\HaloHalo\20100818_1631_myo3Halo_1_HUDS_6417-7338.mat')

t=handles.time;

start=107;%seconds

close all;figure
pv=lowpass1d(phaseVelocity,5);
plot(t(T1:T4-1)-start,pv)

mn=0;
mx=2;

onEvents=find(diff(handles.DLPIsOn_data)==1);
offEvents=find(diff(handles.DLPIsOn_data)==-1);

hold on
for k=1:length(onEvents)
    plot([t(T1+onEvents(k)) t(T1+onEvents(k))]-start, [mn mx],'--k');
    plot([t(T1+offEvents(k)) t(T1+offEvents(k))]-start, [mn mx],'--k');
end

xlim([0 ,t(T4-1)-start])
ylim([0 2])
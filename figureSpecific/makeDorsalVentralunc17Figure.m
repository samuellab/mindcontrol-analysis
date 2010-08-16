%Load in the first data set
load('D:\Analysis\unc17DorsalVentral\20100301_1506_unc17Halo_HUDS_37773-38110.mat')

%Copy the phase velocity.
pv1=phaseVelocity;

%Copy the time
t1=handles.time(T1:T4-1);
dlpOn1=handles.time(T2);
dlpOff1=handles.time(T3);

%Load the second data set
load('D:\Analysis\unc17DorsalVentral\20100301_1506_unc17Halo_HUDS_38098-38431.mat')

%Copy the phase velocity.
pv2=phaseVelocity;

%Copy the time
t2=handles.time(T1:T4-1);
dlpOn2=handles.time(T2);
dlpOff2=handles.time(T3);


%Smooth the phase velocity
sigma=5;
pv1f= lowpass1d(pv1,sigma);
pv2f= lowpass1d(pv2,sigma);


figure; hold on;

plot(t1-dlpOn1, pv1f,'LineWidth',2);
plot(t2-dlpOn2, pv2f,'r','LineWidth',2);
plot([0 0],[0 max([pv1f pv2f])],'--');
plot([dlpOff1-dlpOn1, dlpOff1-dlpOn1],[0 max([pv1f pv2f])],'--');

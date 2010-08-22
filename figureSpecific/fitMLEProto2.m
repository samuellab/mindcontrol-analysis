function x=fitMLEtoExperiment(directory,thresh,stim)
% x=fitMLEtoExperiment(directory)
%
% Go through a directory containing .mat files that were exported with
% aggregateReversals. There should be one .mat file for each "run" 
% (which itself may have once been composed of multiple recordings)
% 
% All of these runs should have been of the same experiment. 
%
% This script combines them all, graphs them and fits an exponential.
%
% 
disp('Welcome. Hit enter to close all windows and continue..');
pause;
close all;
files=ls([directory '\*.mat']);

h = waitbar(0,'Aggregating runs...');
steps = size(files,1);

if ~exist('thresh')
    thresh=-1;
end

figure(1);
xlabel('Time (s)');
ylabel('Change in Phase Velocity (worm length/s)');

figure(2);
xlabel('Time (s)');
ylabel('Binary Response');

T=[]; %time;
Q=[]; %response magnitue
R=[]; %binary response

n=0; %number of worms
for k=1:steps
    
    waitbar(k/ steps)

    
    disp(['Loading ' files(k,:) ' ...' ]);

    
    %Load the file
    load( [directory '\'  files(k,:)],'-mat')
    disp('loaded!');
    %Check to make sure we are dealing with a mat file that was generated
    %from the mindcontrol preview program
    if ( ~exist('t') || ~exist('short'))
        disp([directory '\'  files(k,:) '  does not seem to be a file generated by aggregateReversals.m as expected']  )
        continue
    end
    n=n+1; 
    
    
    %calculate binary response
    r=zeros(size(short));
    r(find(short<thresh))=1;
    
    Ix=find(protocol==stim);
    %Concatenate this data to the existing data;
    T=[T t(Ix)]; %time
    Q=[Q short(Ix)]; %reversal magnitude
    R=[R r(Ix)]; %binary response
    
    
    %plot the reversal magnitude
    figure(1);
    hold on;
    plot(t,short,'o','MarkerEdgeColor',[rand, rand, rand],'LineWidth',2);
    title(['Response Habituation (n=' num2str(n) ' worms)']);

    
    %plot binary response
    figure(2)
    hold on;
    plot(t,r,'o','MarkerEdgeColor',[rand, rand, rand],'LineWidth',2);
    title(['Response Habituation (n=' num2str(n) ' worms)']);
    
    
    clear('t','short','r','Ix','protocol');
end



%Beginning curve fitting
disp('beginning curve fitting');

%a=.1;
a=.2
b=.7;
c=.001;

x0=[a b c];  %initial conditions
lbound=[0,0,0];
ubound=[1,1,10];


f=@(x) sum(-logLikelihood(x(1),x(2),x(3),T,R),2);

%Add in constraint that a+b<1
coef=[1 1 0];
limit=1;

x = fmincon(f,x0,coef,limit,[],[],lbound,ubound)


figure(2)
hold on;
plot(sort(T),x(1)+x(2)*exp(-x(3)*sort(T)),'r');

%%%%%%%%%%%%
% Another way to visualize this is to plot the ration of responses to non
% responses in a sliding window.
figure(3)

%w=250; %bin width in seconds
nb=10; %number of time bins

%Sort the responses as a function of time
[Tsort Ix]=sort(T);
Rsort=R(Ix);

RsortSum=cumsum(Rsort);
m=0;
for k=1:nb
    %These indices correspond to the location of every 200seconds in Tsort
    TsortIxEven(k)=findClosest(Tsort,k*Tsort(end)/nb);
end
NumEventsPerBin=RsortSum(TsortIxEven)-RsortSum([1 TsortIxEven(1:end-1)]);
NumStimuliPerBin=TsortIxEven - [1 TsortIxEven(1:end-1)] ;
Ratio=NumEventsPerBin./(NumStimuliPerBin);
RatioTimeStamps=  ( Tsort(TsortIxEven)+Tsort([1 TsortIxEven(1:end-1)]) )./2;
plot( RatioTimeStamps, Ratio,'o'); hold on;
ylim([0 1]);
ylabel('Ratio of Response to Non-Response');
xlabel('Time (s)');
plot(sort(T),x(1)+x(2)*exp(-x(3)*sort(T)),'r');
title({['Ratio of responses to non responses'];[ ' bin size ' num2str(Tsort(end)/nb) ' seconds wide;(n=' num2str(n) ' worms); \tau=' num2str(1/x(3)/60) ' minutes']});

close(h)
disp('Goodbye.');
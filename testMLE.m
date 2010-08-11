%Let's simulate some data

t=0:100; % time series

%Paramters of our exponential
a=.1;
b=.9;
c=10;
w=a+b.*exp(-t./c);

figure;
plot(t,w);
title('Likelihood of an event over time');

%simulated measurements
%Randomly draw a number between 0 and 1
% if its smaller than w, than score is 1
%Otherwise score it as zero.
% This is equivalent to getting a 1 with probability w
q=zeros(size(w));
q( find(rand(size(w))<w) )=1;

%%%%%%%%% FIREWALL.. treat t & q as real measurements

figure;
plot(t,q,'o');
title('Events');
%now use q, and t to do a Maximum Likelihood Estimate

%NOTE.. ANDY.. don't start my time series at zero, because otherwise
%There will be zero likelihood of getting no response at the first stimuli
%I will need to start my time series some standard time away.



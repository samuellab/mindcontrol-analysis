%Let's simulate some data

t=0:100; % time series

%Paramters of our exponential
a=.1;
b=.8;
c=.1;
w=a+(b-a)*exp(-c*t);
figure(1);
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

figure(2);
plot(t,q,'o');
title('Events');
%now use q, and t to do a Maximum Likelihood Estimate


x0=[a , b , c]+ (.5)*(1-rand(1,3)).*[a, b, c] ; %initial conditions
lbound=[0,0,0];
ubound=[1,1,.5];
f=@(x)sum(logExpPartial(x(1),x(2),x(3),t,q),2);


[x,fval]=lsqnonlin(f,x0,lbound,ubound)
%[x,fval]=fsolve(f,x0,options)

figure(1)
hold on;
plot(t,x(1)+(x(2)-x(1))*exp(-x(3)*t),'r');


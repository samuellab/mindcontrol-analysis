function [tanhCoef,tanhGOF, c1, c2]= findcorners(data);
ymax=max(data);
ymin=min(data);
xmax=length(data);
xmin=0;

%Let's fit to a hyperbolic tangent
%B is the halfway between forward and backwords
%B+A  is one steady state velocity
%B-A is the other steady state velocity
%x0 is the center of the change in speed
%x0 +/- 1/beta is the start and end of the change in speed
 s=fitoptions('Method','NonlinearLeastSquares',...
      'Lower',[ymin, ymin, -Inf, xmin],...
     'Upper',[ymax, ymax, Inf, xmax],...
     'Startpoint',[(ymax-ymin)/2, (ymax-ymin)/2,1,(xmax-xmin)/2]);
  fitTanh=fittype('A*tanh(beta*(x-x0))+B','options',s)
 x= 1:length(data);
 [tanhCoef,tanhGOF]=fit(x',data',fitTanh);
 A=tanhCoef.A;
 beta=tanhCoef.beta;
 x0=tanhCoef.x0;
 B=tanhCoef.B;
 y=A*tanh(beta.*(x-x0))+B;
 
 figure; hold on;
 plot(x,data)
 plot(x,y,'m','linewidth',2)
 plot([x0+1/beta x0-1/beta],[A+B B-A],'ro','linewidth',3);
 
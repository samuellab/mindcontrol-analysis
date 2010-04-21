function out= findWaveVel(curvdata,delt,delx);
% Given a matrix of curve data this function will find the worm's wave
% velocity

%let k = curvature
figure;
%dkdt=diff(curvdata);
%dkdx=diff(curvdata')';
clear dkdt;
clear dkdx;
%delt=5; %windowing over 
%delx=1;
dkdt=( curvdata(1:end-delt, :)- curvdata(circshift([1:size(curvdata,1)-delt]',[delt 0]),:) )./delt;
dkdx= ( curvdata(:, 1:end-delx)-curvdata(:,circshift([1:size(curvdata,2)-delx],[0 delx])))./delx;
clear slope;

for j=1:size(dkdt,1) %note dkdt is one shorter than dkdtx in this dimension
   % plot(dkdx(j,:),dkdt(j,1:end-1),'o')
    slope(j)=dkdx(j,:)/dkdt(j,1:end-delx);
end
plot(1:length(slope),slope,'o')
out=slope;

ymax=max(slope);
ymin=min(slope);
xmax=length(slope);
xmin=1;

%Let's fit to a hyperbolic tangent
%B is the halfway between forward and backwords
%B+A  is one steady state velocity
%B-A is the other steady state velocity
%x0 is the center of the change in speed
%x0 +/- 1/B is the start and end of the change in speed
 s=fitoptions('Method','NonlinearLeastSquares',...
     'Lower',[ymin, ymin, -Inf, xmin],...
     'Upper',[ymax, ymax, Inf, xmax],...
     'Startpoint',[(ymax-ymin)/2, (ymax-ymin)/2,1,(xmax-xmin)/2]);
  fitTanh=fittype('A*tanh(beta*(x-x0))+B','options',s)
 [c,gof]=fit([1:length(slope)]',slope',fitTanh);
 
 

 
out=function findWaveVel(curvdata)
% Given a matrix of curve data this function will find the worm's wave
% velocity

%let k = curvature
figure;
%dkdt=diff(curvdata);
%dkdx=diff(curvdata')';
clear dkdt;
clear dkdx;
delt=5; %windowing over 
delx=1;
dkdt=curvdata(1:end-delt, :)- curvdata(circshift([1:size(curvdata,1)-delt]',[delt 0]),:);
dkdx=curvdata(:, 1:end-delx)-curvdata(:,circshift([1:size(curvdata,2)-delx],[0 delx]));
clear slope;

for j=1:size(dkdt,1) %note dkdt is one shorter than dkdtx in this dimension
   % plot(dkdx(j,:),dkdt(j,1:end-1),'o')
    slope(j)=dkdx(j,:)/dkdt(j,1:end-delx);
end
plot(1:length(slope),slope)
slope=out;
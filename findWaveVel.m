function out= findWaveVel(curvdata,delt,delx);
% Given a matrix of curve data this function will find the worm's wave
% velocity



% delt=5; %windowing over 
% delx=1;
%dkdt=( curvdata(1:end-delt, :)- curvdata(circshift([1:size(curvdata,1)-delt]',[delt 0]),:) )./delt;
%dkdx= ( curvdata(:, 1:end-delx)-curvdata(:,circshift([1:size(curvdata,2)-delx],[0 delx])))./delx;

dkdt= deriv(curvdata',delt)';
dkdx=deriv(curvdata,delx);

for j=1:size(dkdt,1) %note dkdt is one shorter than dkdtx in this dimension
   % plot(dkdx(j,:),dkdt(j,1:end-1),'o')
    slope(j)=-dkdx(j,:)/dkdt(j,:);
end
out=slope;


 

 
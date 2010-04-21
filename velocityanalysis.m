
nu=findWaveVel(curvdata,5,1);
[tanhCoef,tanhGOF, c1, c2]= findcorners(nu);
 x=1:length(nu);
 %Plot Output:

 figure; hold on;
 A=tanhCoef.A;
 beta=tanhCoef.beta;
 x0=tanhCoef.x0;
 B=tanhCoef.B;
 y=A*tanh(beta.*(x-x0))+B;

 hold on;
 subplot(1,2,1)
 imagesc(curvdata);
 subplot(1,2,2)
 hold on;
 plot(nu,x)
 plot(y,x,'m','linewidth',2)
 plot([A+B B-A],[x0+1/beta x0-1/beta],'ro','linewidth',3);
set(gca,'Ydir','reverse');
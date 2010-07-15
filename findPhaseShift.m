function ps = findPhaseShift(curvdata,headCrop,tailCrop,alpha,sigma)
% Find the phase shift by shifting in x the the n'th frame and comparing it
% to the (n+1)th frame and recording the shift that gets the best fit.
% 
% The curvature data is low pass filtered with sigma specified by sigma.
%
% Additionally, to filter out noise, the nth frame is averaged with the
% (n-1)th from accordint to a weighting factor, alpha. 
%
% Moreover the head is cropped a certain porectange according to headCrop, 
% and a percentage of the tail is cropped according to tailCrop.
%
%
% written by Marc Gershow
% Modified by Andrew Leifer


debug = false;
sigma = 5;
%pre-allucate the phase shift vector
ps = zeros([1 (size(curvdata,1)-1)]);

headCrop=.2;
tailCrop=0.05;

%pre allocate x shift
xs = 1:size(curvdata,2);

%crop index
cinds = xs (floor(length(xs)*headCrop):ceil(length(xs)*(1-tailCrop)));

%This is a function that just shifts xdata some amount x 
shiftfn = @(x,xdata) interp1(xs, xdata, cinds + x,'linear');
x = 0;
op = optimset('lsqcurvefit');
op.Display = 'off';
curvaccumulated = lowpass1d(curvdata(1,:),sigma);
alpha_accum = 0.85;
for j = 1:length(ps)
   %find the phase shift by doing a least squares fit
   tofitdata = lowpass1d(curvdata(j+1,:),sigma);
   x = lsqcurvefit(shiftfn, x, curvaccumulated, tofitdata(:,cinds),-length(xs)*headCrop, length(xs)*tailCrop, op);
   curvaccumulated = alpha_accum * interp1(xs,curvaccumulated,xs+x,'linear','extrap') + (1-alpha_accum) * tofitdata;
   ps(j) = x; %record the phase shift
   if (debug)
       plot (xs, curvaccumulated, xs, tofitdata); ylim([min(curvdata(:)), max(curvdata(:))]);
       legend ('average', 'current');
       title (num2str(j));
       pause(0.05);
   end
end

%implement lowpass1d filter for output


%Sum the individual phase shifts to get a cumulitive phase shift
%ps = cumsum(ps);

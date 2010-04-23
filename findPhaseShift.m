function ps = findPhaseShift(curvdata)
% Find the phase shift by shifting in x the the n'th frame and comparing it
% to the (n+1)th frame and recording the shift that gets the best fit.
% written by Marc Gershow
% Modified by Andrew Leifer



%pre-allucate the phase shift vector
ps = zeros([1 (size(curvdata,1)-1)]);

fracCrop=.1;

%pre allocate x shift
xs = 1:size(curvdata,2);

%crop index
cinds = xs (floor(length(xs)*fracCrop):ceil(length(xs)*(1-fracCrop)));

%This is a function that just shifts xdata some amount x 
shiftfn = @(x,xdata) interp1(xs, xdata, cinds + x,'linear');
x = 0;
op = optimset('lsqcurvefit');
op.Display = 'off';
for j = 1:length(ps)
   x = lsqcurvefit(shiftfn, x, curvdata(j,:), curvdata(j+1,cinds),-length(xs)*(1-fracCrop), length(xs)*(1-fracCrop), op);
   ps(j) = x;
end

%Sum the individual phase shifts to get a cumulitive phase shift
%ps = cumsum(ps);

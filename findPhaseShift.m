%  Copyright 2010 Andrew Leifer et al <leifer@fas.harvard.edu>
%  This file is part of Mindcontrol-analysis.
% 
%  Mindcontrol-analysis is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  Mindcontrol-analysis is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with mindcontrol-analysis. If not, see <http://www.gnu.org/licenses/>.




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
%
%
% For the most up to date version of this software, see:
% http://github.com/samuellab/mindcontrol
% 
% NOTE: If you use any portion of this code in your research, kindly cite:
% Leifer, A.M., Fang-Yen, C., Gershow, M., Alkema, M., and Samuel A. D.T.,
%   "Optogenetic manipulation of neural activity with high spatial resolution
%   in freely moving Caenorhabditis elegans," Nature Methods, Submitted
%   (2010).
% 




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
try   x = lsqcurvefit(shiftfn, x, curvaccumulated, tofitdata(:,cinds),-length(xs)*headCrop, length(xs)*tailCrop, op);
catch
    disp('least squares curve fit failed!')
    disp('Just fudging it and saying the velocity is the previous veloctiy.')
end
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

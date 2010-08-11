function [i] = findClosest(vector, value)
% simple function to find the element in vector closest to value
%
% Adapted from James J Cai's comment at:
% http://www.mathworks.com/matlabcentral/fileexchange/15088-search-closest-value-in-a-vector
%
% Written by Andrew Leifer
% leifer@fas.harvard.edu
%

z=abs(vector-value);
[k]=find(min(z)==z);
i=k(1); %choose the first one if there are multiple closest vectors.

    
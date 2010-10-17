function g = gaussKernel (sigma)
%function g = gaussKernel (sigma)
%
%returns a normalized gaussian 6 sigma in total width, with standard
%deviation sigma
% by Marc Gershow

x = floor(-3*sigma):ceil(3*sigma);
g = exp(-x.^2/(2 * sigma.^2));
g = g./sum(g);


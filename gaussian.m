function g = gaussian (x, m, s)
%function g = gaussian (x, m, s)
g = (1/sqrt(2*pi*s^2))*exp(-(x-m).^2/(2*s^2));
dx = diff(x);
dx(end+1) = dx(end);
g = g.*dx;

function [dx,validinds] = deriv(x,sigma)
%function [dx,validinds] = deriv(x,sigma)
%Always takes the derivitave in the 1st dimension (i think)
%This is a modification of Marc Gershow's deriv function

% if (size(x,1) > size(x,2))
%     xx = x';
%     t = 1;
% else
%     xx = x;
%     t = 0;
% end
xx=x;
t=0;
dg = reshape(dgausskernel(sigma),1,[]);

padfront = ceil ((length(dg)-1) / 2);
padback = length(dg) - padfront - 1;

xx = [repmat(xx(:,1), 1, padfront) xx repmat(xx(:,end), 1, padback)];

dx = conv2(1,dg,xx,'valid');

if (t)
    dx = dx';
end
len = ceil(length(dg)/2);
if (2 * len > length(dx))
    validinds = [];
else
    validinds = (len:length(dx)-len);
end
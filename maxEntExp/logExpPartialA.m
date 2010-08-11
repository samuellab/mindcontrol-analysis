function dlnP_da=logExpPartialA(a,b,c,t,r)
% This takes the partial derivative of the natural log of the probability of 
% a binary event occouring, given an exponentialy decaying weighting factor. 
% This is the model I use for habituation. r reprosents a response to a
% stimuli at time t and is either 0 or 1. 
%
% The probability of of an event is related to an exponentialy decaying
% weight factor w:
% P(r,w) = w if r==1; or P(r,w) = 1-w if r==0
%
% alternatively,
% P(r,w)=1+w(2r-1)-r 
%
% Where,
% w = a + b * exp(-t/c) 
% 
% Thus
%
% P(r,a,b,c,d,t) = 1- r + 2(r-1) * ( a+b*exp(-t/c) ) 
% 
% Here we take the natural log of this expression
% and the partial derivative with respect to parameter a
%
% by Andrew Leifer
% leifer@fas.harvard.edu
% Inspired by discussions with Benjamin Schwartz and Subhy Lahiri
%

dlnP_da =  (2*r-1 ) /  ( 1-r+(2*r-1)*(a+b *exp(-t/c)) );
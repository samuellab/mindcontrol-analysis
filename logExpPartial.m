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




function partial=logExpPartial(a,b,c,t,r)
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
% w = a + (b-a) * exp(-c*t) 
% 
% (Note the funky choice of parameters is so that a and b can be set to be
% in the range of 0 to 1. You can think of alpha=a; beta=(b-a); tau=1/c;)
%
% Thus
%
% P(r,a,b,c,d,t) = 1- r + 2(r-1) * ( a + (b-a) * exp(-c*t)) 
% 
% Here we take the natural log of this expression
% and the partial derivative with respect to parameters a, b & c
%
% by Andrew Leifer
% leifer@fas.harvard.edu
% Inspired by discussions with Benjamin Schwartz and Subhy Lahiri
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

partial =  [(2*r-1 ) .*(1-exp(-c*t)) ./ ( 1-r+(2*r-1).*(a+(b-a)*exp(-c*t)) ) ;...
            (2*r-1 ).*b.*exp(-c*t)  ./  ( 1-r+(2*r-1).*(a+(b-a)*exp(-c*t)) );...
            (2*r-1 ).*(b-a).*(-t) .* exp(-c*t)  ./  ( 1-r+(2*r-1).*(a+(b-a)*exp(-c*t)) ); ];
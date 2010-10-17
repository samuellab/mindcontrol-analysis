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


function N=parseCVDateType(string)
% Converts the date from a custom string format to Matlab's "serial date
% number"
%
% As of version 8db88227a3519800cb8968d8a51c3eb640f57b08 of the MindControl
% software, YAML data files are written with a date stamp in a particular format. 
% 
% For example:
%
% ExperimentTime: "Wed Jul 28 10:35:33 2010\n"
%
% This function parses that format.
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


[match split]=regexp(string,'[0-9]*','match','split');
d=str2num(match{1});
h=str2num(match{2});
mi=str2num(match{3});
sec=str2num(match{4});
y=str2num(match{5});

clear match;
clear split;
[match split]=regexp(string,'[A-Z]+[a-z]+','match','split');
switch match{2}
    case 'Jan'
        m=1;
    case 'Feb'
        m=2;
    case 'Mar'
        m=3;
    case 'Apr'
        m=4;
    case 'May'
        m=5;
    case 'Jun'
        m=6;
    case 'Jul'
        m=7;
    case 'Aug'
        m=8;
    case 'Sep'
        m=9;
    case 'Oct'
        m=10;
    case 'Nov'
        m=11;
    case 'Dec'
        m=12;
end
m=m;

N=datenum(y,m,d,h,mi,sec);
end
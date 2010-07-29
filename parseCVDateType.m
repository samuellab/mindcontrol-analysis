
function N=parseCVDateType(string)
% Converts the date from a custom string format to Matlab's "serial date
% number"
%
% As of version 8db88227a3519800cb8968d8a51c3eb640f57b08 of the MindControl
% software, YAML data files are written with a date stampe in a particular format. 
% 
% For example:
%
% ExperimentTime: "Wed Jul 28 10:35:33 2010\n"
%
% This function parses that format.

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

N=datenum(y,m,d,h,mi,sec)
end
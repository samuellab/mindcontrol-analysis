function x = assignApplicable(x)
% PVPMOD             - evaluate parameter/value pairs
% pvpmod(x) assigns the value x(i+1) to the parameter defined by the
% string x(i) in the calling workspace if and only if the calling function
% already has a parameter by the name x{i} defined
% otherwise, does nothing
% unused parameter-value pairs are returned in x
% This is useful to evaluate 
% <varargin> contents in an mfile, e.g. to change default settings 
% of any variable initialized before pvpmod(x) is called.
%
% modified by marc gershow from pvpmod by
% (c) U. Egert 1998

%############################################
% this loop is assigns the parameter/value pairs in x to the calling
% workspace.
used = [];
vars =  evalin('caller', 'who');
if ~isempty(x)
    skipnext = false;
   for i = 1:size(x,2)
       if skipnext
           skipnext = false;
           continue;
       end
       if (isstr(x{i}) && any(strcmp(x{i},vars)))         
          assignin('caller', x{i}, x{i+1});
          used = [used i];
          skipnext = true;
       end
   end;
end;
if (~isempty(used))
    used = [used used+1];
    inds = setdiff(1:length(x), used);
    x = x(inds);
end

%############################################


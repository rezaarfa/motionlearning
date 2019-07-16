function Y = which_interval(X, intrvls, mode)

%WHICH_INTERVAL check x is in wich interval
%   Dist = WHICH_INTERVAL(x, intervals) check a real value x is in which of
%   interval of intrvls. 
%   assume intrvls = [0 10 20 30] and X=11.2, then 10<=X<20 and the function
%   returns 2
% 
% 
%   Example 1
%   ----------
%       X      = [-2 11 2c 35];
%       intrvls= [0 10 20 30];
%       Y      = which_interval(X, intvls)          % [1    2   3   4]
%       Y      = which_interval(X, intvls, 'NAN')   % [NAN  2   3   NAN]
% 
% 
%   Reza Arfa, JUN 2015.

if nargin<3
    mode = 'CUTOFF';
end


fun = @(x) which_interval_singleX(intrvls, x, mode);
Y = cell2mat(arrayfun(fun,X,'UniformOutput', false));
end





% ---------------------------------------------------------
function y = which_interval_singleX(intrvls, x, mode)
y = find(intrvls > x, 1, 'first') - 1;
if isempty(y)
    if strcmp(mode, 'NAN')
        y = nan;
    elseif strcmp(mode, 'CUTOFF')
        y = length(intrvls) - 1;
    end
end

if y==0
    if strcmp(mode, 'NAN')
        y = nan;
    elseif strcmp(mode, 'CUTOFF')
        y = 1;
    end
end

end







function [Y idx] = topvals(X, n, MODE)

%TOPVALS return the top maximum (or minimum) of array X
%   [Y idx] = TOPVALS(X, n, mode) returns top n maximum (or minimum if 
%             mode='min') of X. mode can get a value "min" (default) or 
%             "max". 
% 
% 
%   Example
%   -------
%       X = [2 1 4 3];
%       [Y idx] = topvals(X, 2, 'max');
% 
% 
%   Reza Arfa, JUN 2015.

if nargin<3 || isempty(MODE)
    MODE = 'min';
end


if strcmp(MODE, 'min')
    [ma,idx]=sort(X);
    Y   = ma(1:n);
    idx = idx(1:n);
    
elseif strcmp(MODE, 'max')
    [ma,idx]=sort(X, 'descend');
    Y   = ma(1:n);
    idx = idx(1:n);
    
else
    error('mode can be "min" or "max" ');
    
end


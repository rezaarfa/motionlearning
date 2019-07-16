function W = table_stats(D, T)

%TABLE_STATS statistics of each table
%   W = TABLE_STATS(D, Table_label) sum all the values on each table
% 
% 
%   Example
%   -------
%       D   = [1 10 0 10 1;0 8 0 6 1];
%       T   = [1 2 1 2 1];
%       W   = table_stats(D, T) % [2 20;1 14]
%       
%   Reza Arfa, JUN 2015.

L  = size(D, 1);
nT = length(unique(T));
W  = zeros(L, nT);
for i = 1:nT
    W(:, i) = sum(D(:, T==i), 2);
end

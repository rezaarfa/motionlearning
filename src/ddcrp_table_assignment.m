function [Tables nT]= ddcrp_table_assignment(Pick)

%DDCRP_TABLE_ASSIGNMENT connect customers which chose each other to a seat
%on a table!
%   T = DDCRP_TABLE_ASSIGNMENT(Cust, Pick) groups the customer who chose
%   each other and give them a unique labels
% 
%
% 
% 
%   Example
%   -------
%       pick  = [2 1 4 1 5 5];
%       Tables= ddcrp_table_assignment(pick) %[1 1 1 1 2 2]
%
%       pick = [1 3 3 5 5 6];
% 
%   Reza Arfa, JUN 2015.


N = length(Pick);

DG = sparse(1:N, Pick, true, N, N);

[nT, Tables] = graphconncomp(DG, 'WEAK', true);
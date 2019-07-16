function M = find_mapping_between(A, B)

%FIND_MAPPING_BETWEEN finds the mapping between A and B
%   W = FIND_MAPPING_BETWEEN(A, B) finds the best 1-to-1or or 1-to-many 
%   mapping between A and B.
%
%   Reza Arfa, JUN 2015.

K       = length(unique(A(:)));
Q       = length(unique(B(:)));
N       = size(A,1);

Diagram = sparse(A, B, ones(1, N), K, Q);

[X Y]   = find(Diagram);

M = [X(:) Y(:)];
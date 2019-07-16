function O  =   map(Z, D, R)

%MAP maps the Z from domain "D" to range "R". 
% 
%   O=map(Z): rearange Z from domain unique(Z) to range 1:length(unique(Z))
%   O=map(Z, D, R): rearanges Z from domain D to range R. 
% 
%   Example
%   -------
%       Z = [1 3 3 7]
%       O = map(Z)                      % returns [1 2 2 3]
%       O = map(Z, [1 3 7], [0 1 8])    % returns [0 1 1 8]
% 
%   Reza Arfa, JUN 2015.

U = unique(Z);
d = length(U);

if nargin==1
    D = U;
    R = 1:d;
elseif nargin==3
    if ~all(ismember(U,Z))
        error('all the values of Z  should exist in domain ') 
    end
    if size(D)~=size(R)
        error('size of domain and range should be the same') 
    end
else
   error('incorrect number of inputs') 
end

O = Z;
for i = 1:d
   O(Z==U(i)) = R(i); 
end




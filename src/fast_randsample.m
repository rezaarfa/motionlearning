function z = fast_randsample(P)
%FAST_RANDSAMPLE generates one sample random sample from distribution p
%   z = fast_randsample(p) generate sample from p and return the sample
%
%   Example
%   -------
%       P = [0.4 0.2 0.3 0.1];
%       z = fast_randsample
%
%   Reza Arfa, JUN 2015.

C = [0, cumsum(P)];
C(end) = 1;
try
    [temp, z] = histc(rand(1,1), C);
catch ME
    K = length(P);
    z = randsample(K, 1, true ,P);
end
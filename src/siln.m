function S = siln(D)

%SILN calculates log of Multinomial Coefficient function of X
%   si = siln(X) returns log of si function
%
%                   gamma(x1+1) ... gamma(xL+1)
% SI(x)        =  ------------------------------   ; "L" is # of features
%                    gamma(x1 + ... + xL + 1)
% 
% 
%   Reza Arfa, JUN 2015.

X0 = sum(D,1);
S  = sum(gammaln(D + 1),1) - gammaln(X0 + 1);

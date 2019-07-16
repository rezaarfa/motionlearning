function B = mvnbeta(D)

%MVNBETA calculates multivariate beta function 
%   B = mvnbeta(D);
% 
%                   gamma(x1) ... gamma(xd)
% mvnbeta(X) =    --------------------------   ; "d" is # of features
%                    gamma(x1 + ... + xd)
% 
% 
%   Example
%   -------
%       y = mvnbetaln([2.1, 1.0, 5.1
%                      2.2, 1.1, 5.8]) % returns [-2.03, -0.09, -7.09]
% 
% 
% see also: MVNBETALN
%
%   Reza Arfa, JUN 2015.

B = prod(gamma(D), 1) ./ gamma(sum(D));
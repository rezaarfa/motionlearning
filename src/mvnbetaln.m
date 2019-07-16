function B = mvnbetaln(D)

%MVNBETALN logarithm of multivariate beta function
%   B = MVNBETALN(D) computes the logarithm of the multivariate beta 
%   function. D is the input matrix, where each column contains a datapoint
%   (Xi). We have:
%   mvnbetaln(X) =  (gammaln(x1)+...+gammaln(xd))  -  gammaln(x1+ ... +xd)
% 
% 
% 
%   Example
%   -------
%       D = [2.1, 1.0, 5.1; 2.2, 1.1, 5.8]
%       y = mvnbetaln(D)                    % returns [-2.03, -0.09, -7.09]
%
% 
% see also: MVNBETA
%
%   Reza Arfa, JUN 2015.

B   =   sum(gammaln(D),1)    -   gammaln(sum(D,1));






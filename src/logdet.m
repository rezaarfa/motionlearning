function y = logdet(X)

%LOGDET approximates logarithm of determinant of X without going to inf
%   y = logdet(X) calculates logarithm of determinant of X
% 
%   Inputs
%   -------------
%   X       [L-by-L]    :   The matrix which you want to find log(det(X))
%                           if X is singular, logdet returns -inf
% 
%   Outputs
%   -------------
%   y       [1-by-1]    :   log(det(X))
% 
%   Example
%   -------
%       A = magic(1000);
%       y1= logdet(A);
%       y2= log(det(A));
% 
%   Reza Arfa, JUN 2015.

[~, U, P] = lu(X);
y = log(det(P) * prod(sign(diag(U)))) + sum(log(abs(diag(U))));
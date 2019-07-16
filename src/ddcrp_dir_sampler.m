function [PicksS, ZS, BlW_lnS, PCS_ln, WS] = ...
                ddcrp_dir_sampler(D, fD, S, alpha, lambda, Picks0)

%DDCRP_DIR_SAMPLER obtains S sample from ddCRP for the scenario that P(X) 
%is mul-dir! 
%   [PicksS, Z] = DDCRP_DIR_SAMPLER(D, fD, S, alpha, lambda) returns S 
%   samples with ddCRP algorithm and also assigned table for each sample
%   (Z). The assigned samples actually are the labels of each N samples
% 
% 
%   Example 1 : how to this function as gibbs sampler with S samples
%   ----------
%       D     = [1 10 0 10 1;0 8 0 6 1];
%       Labels= [1,2, 1, 2, 1]
%       fD = exp(-.5*dist(D));
%       S = 100;
%       alpha = .4;
%       lambda= [1;1];
%       [PicksS1, Z] = ddcrp_dir_sampler(D, fD, S, alpha, lambda);
% 
%       [acc ZZ] = ddcrp_accuracy(Labels, Z);
%       pLabkes  = mode(ZZ);
%       acc*100
%       [Labels; pLabkes]
%             
% 
% 
% 
%   Example 2 : continue to create 20 more samples
%   ----------
%       [PicksS2, Z] = ddcrp_dir_sampler(D, fD, 20, alpha, PicksS1(end,:));
%      
% 
% 
%   Reza Arfa, JUN 2015.


[L, N]  = size(D);

% % Progress bars
total_steps=S*N;    each_step=floor(N/20);     counter=0;

% % Initializing PICKS
PicksS 	= zeros(S+1, N);
if nargin<6
    for i = 1:N
        PicksS(1, i) = fast_randsample(fD(i,:));
    end
else
    PicksS(1, :) = Picks0;
end

% % Initializing Z
Z   	= zeros(S+1, N);
Z(1, :) = ddcrp_table_assignment(PicksS(1,:));
W       = table_stats(D, Z(1, :));

% % Drive fD_prime, by adding alpha
eps=1e-6;%new added this
fD_prime = bsxfun(@rdivide, fD, (sum(fD, 2)-diag(fD)) / (1-alpha)+eps); % new:added eps
fD_prime(logical(eye(size(fD_prime)))) = alpha;

% % Sampling
WS      = cell(1,S);
BlW_lnS = cell(1,S); 
PCS_ln  = zeros(S,1);
BlW_ln  = mvnbetaln(bsxfun(@plus, W, lambda));
Bl_ln   = mvnbetaln(lambda);

for s = 2:S+1
    fprintf('\n generating sample %i ', s-1);
    
    temp    = PicksS(s-1,:);
    I       = randperm(N);
    PCi     = zeros(1,N);
    
    for ii = 1:N
        i = I(ii);
        fd= fD_prime(i,:);
        
        [temp(i), PCi(i), BlW_ln]=...
                ddcrp_dir(D, i, temp, fd, lambda, Bl_ln, BlW_ln);
        
        counter = counter+1;
        if rem(ii, each_step)==0
            fprintf('.');
        end
        
    end
    
    PCS_ln(s-1) = sum(log(PCi));
    BlW_lnS{s-1}= BlW_ln;
    
    PicksS(s,:) = temp;
    Z(s, :) = ddcrp_table_assignment(PicksS(s,:));
    WS{s-1} = table_stats(D, Z(s, :));
    
    fprintf('\n==> sample %i generated (%.1f%%)\n',...
                                            s-1, counter/total_steps*100);
end

ZS = Z(1:end,:);
PicksS = PicksS(1:end,:);







function [Ci, PCi, BlW_ln2]=ddcrp_dir(D,custID,Picks,fd,lambda,Bl_ln,BlW_ln)

%DDCRP_DIR is gibbs sampler for distance dependent CRP for the scenario 
%that P(X) is mul-dir! 
%   Picks_new = DDCRP_DIR(D,custID,Picks,fD,alpha,lambda,Blambda_ln) 
%   returns new Pick for CustID. 
% 
% 
%   Example 1 : how to this function as gibbs sampler with S samples
%   ----------
%       D     = [1 10 0 10 1;0 8 0 6 1];
%       Picks = [2 3 4 3 5];                % a-->b-->c<-->d, e
%       fD    = exp(-.5*dist(D));
%       alpha = 0.5;
%       lambda= [1;1];
%       Blambda_ln = mvnbetaln(lambda);
%       S = 10;
%       Picks2=zeros(S+1, size(Picks,2));
%       Picks2(1,:) = Picks;
%       for s = 2:S+1
%           temp = Picks2(s-1,:);
%           for i = 1:length(Picks)
%               temp(i) = ddcrp_dir(D,i,temp,fD,alpha,lambda,Blambda_ln);
%           end
%           Picks2(s,:) = temp;
%       end
%       clc
%       Picks2
%       D
%       old_labels = ddcrp_table_assignment(Picks)
%       new_labels = ddcrp_table_assignment(Picks2(s,:))
%       true_labels= [1 2 1 2 1]
%       
%       
%       
% 
%   Reza Arfa, JUN 2015.


[L, N]              = size(D);

customer            = custID;
refered_customer    = Picks(customer);


% STEP 1 -  cute the wire of custID and rewire it to himself. Rearrange 
%           BlW_ln if this action disconnects two tables
Picks_new           = Picks;
Picks_new(customer) = customer;

[T0 nt0] = ddcrp_table_assignment(Picks);    % T0:previous table assignment
[T1 nt1] = ddcrp_table_assignment(Picks_new);% T1:current table assignment

if nt0~=nt1                % if seperated any two tables, rearrange BlW_ln:
    temp   = zeros(1, nt1);
    mapping= find_mapping_between(T0, T1);
    
    new_table       = T1(refered_customer); % new table to be created
    old_table       = T1(customer);         % old table to be modified

    BlW_new_table   = mvnbetaln(sum(D(:, T1==new_table), 2) + lambda);
    BlW_old_table   = mvnbetaln(sum(D(:, T1==old_table), 2) + lambda);
    
    for i = 1:nt1
        t = mapping(i, 2);
        if t~= new_table && t~=old_table
           temp(t) = BlW_ln(mapping(i,1));
        end
    end
    
    temp(new_table) = BlW_new_table;
    temp(old_table) = BlW_old_table;
    
    BlW_ln = temp; 
end
W = table_stats(D, T1);


% STEP 2 -  resample the connection of custID
% fD(:, custID) = fD(:, custID)/sum(fD(:, custID)); %normalize the distance
Wl      = W(:, T1(custID));
BWl_ln  = BlW_ln(T1(custID));

P = zeros(1, N);
BWkl_ln_temp = zeros(1,N);

% % % % % % % % % 1 - doesn't merge
[dummy j]   = find(T1 == T1(custID));
P(j)     = fd(j);

% % % % % % % % % 2 - merge tables
[dummy j]       = find(T1 ~= T1(custID));
temp_tables     = T1(j);
BWk_ln          = BlW_ln(temp_tables);  
temp_tables_unq = unique(temp_tables);
Wk_unq          = W(:, temp_tables_unq);
BWkl_ln         = zeros(1, length(j)); % find BWkl_ln
BWkl_ln_unq     = mvnbetaln(bsxfun(@plus, Wl+lambda, Wk_unq));
for i=1:length(temp_tables_unq)
    inds = temp_tables==temp_tables_unq(i);
    BWkl_ln(inds) = BWkl_ln_unq(i);
end
% val = (Bl_ln + BWkl_ln) - (BWl_ln + BWk_ln); % new
% val = min(val, 10); % new
% px  = exp(val)'; % new: added these recent 3 lines above instead of down
px = exp((Bl_ln + BWkl_ln) - (BWl_ln + BWk_ln))'; % new: commented thos
P(j)         = fd(j)' .*  px(:);
BWkl_ln_temp(j) = BWkl_ln;


% % % % % % % % % 3- choose himself
P(custID) = fd(custID); % which is alpha


% STEP 3 -  sample new connection
P1= P;
% P = P + 1e-5; % new: added this
% P = abs(P);   % new: added this
P  = P/sum(P);      % normalise P
P = abs(P); % new: commented this
try
    Ci = fast_randsample(P);
catch ME
    fd(j)'
%     px(:)
end
PCi= P(Ci);



% STEP 4 - if the rewiring connected any two tables, rearrange BlW_ln2
previous_table = T1(custID);
current_table  = T1(Ci);

if previous_table == current_table                       % 1- doesn't merge
    BlW_ln2 = BlW_ln;
    
else                                                     % 2- merge tables
    min_table = min(previous_table, current_table);
    max_table = max(previous_table, current_table);
    
    BlW_ln2             = BlW_ln(1:end ~=max_table);
    BlW_ln2(min_table)  = BWkl_ln_temp(Ci);
end
end





















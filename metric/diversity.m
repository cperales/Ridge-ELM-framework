function [ div ] = diversity( clf )
% This function measures the diversity of an ensemble.
%% PAIRS
count = 0;
div = 0;
for i=1:clf.ensembleSize-1
    beta_i = clf.OutputWeight{i};
    for j=i+1:clf.ensembleSize
        beta_j = clf.OutputWeight{j};
        for m=1:clf.t
            beta_i_m = beta_i(:,m);
            beta_j_m = beta_j(:,m);
%             u_i_m = beta_i(:,m) ./ norm(beta_i(:,m), 2);
%             u_j_m = beta_j(:,m) ./ norm(beta_j(:,m), 2);
            div_step = 1 - (beta_i_m' * beta_j_m * beta_j_m' * beta_i_m) / (beta_i_m' * beta_i_m * beta_j_m' * beta_j_m);
            div = div + div_step;
            count = count + 1;
        end
    end
end
div = div / count;
end

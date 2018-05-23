function [T] = Jencoding(Targ, numberTarg)
% :Targ: Matrix of labels.
% :numberTarg: (Optional) Number of targets.
%
% This function takes a target from Y encoding to J encoding.

    if size(Targ, 2) == 1
        
        if nargin < 2
            avaTarg = unique(Targ);
            numberTarg = length(avaTarg);
        else
            avaTarg = 1:numberTarg;
        end
        
        T = [];
    	n = size(Targ,1);
        for i=1:n
            new_t = zeros(1, numberTarg);
            new_t(find(avaTarg == Targ(i))) = 1;
            T = [T; new_t];
        end
    else 
        T = Targ; %1 of J encoding training dataset (hat(Y))
    end

end
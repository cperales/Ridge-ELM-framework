function [T] = Yencoding(Targ)
% (TESTING) This function enconde as SVM.

    avaTarg = unique(Targ);
    if all(avaTarg == [-1, 1])  % It is already encoding
        T = Targ;
    elseif size(avaTarg) > 2  % It cannot be encoded
        msg = 'Target is not binary. Solution not implemented.';
        error(msg)
    else  % Encoding
        T = [];
        n = size(Targ, 1);
        for i=1:n
            if Targ(i) == avaTarg(1)
                new_t = 1;
            else
                new_t = -1;
            end
            T = [T; new_t];
        end
    end
end
function [ T ] = Jrenorm( T )
% :T: matrix of n target as J-encode (n x J), but with numbers different from 1 and 0.
%
% Renormalization of a J encoded target.

[~, max_idx] = max(T,[],2);
T = zeros(size(T));
for r=1:size(T,1)
    T(r, max_idx(r)) = 1;
end

end

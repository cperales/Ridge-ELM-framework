function [ Targ ] = Jdecoding( T )
% :T: Matrix of targets.
%
% This function takes a target from J encoding to Y encoding.

[maxValue, TargRow] = max(T');
Targ = TargRow';

end

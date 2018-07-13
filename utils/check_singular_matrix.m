function [ boolean ] = check_singular_matrix( matrix )
%CHECK_SINGULAR_MATRIX Summary of this function goes here
%   Detailed explanation goes here

% OLD
[L,U,P] = lu(matrix);
% cond = abs(prod(diag(U)));
cond_matrix = abs(prod(diag(U)));

% % NEW
% cond_matrix = cond(matrix);

% isnan(rcond(rcond(matrix))) ||

if cond_matrix < 1e-14
    boolean = true;
else
    boolean = false;
end
end

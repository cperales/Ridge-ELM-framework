function [ boolean ] = check_singular_matrix( matrix )
% Function that check if matrix is singular
% True if it is singular, False if not

% % Eigenvalues
[L,U,P] = lu(matrix);
% cond = abs(prod(diag(U)));
cond_matrix = abs(prod(diag(U)));

% % Cond number
% cond_matrix = cond(matrix);
% isnan(rcond(rcond(matrix))) ||

if cond_matrix < 1e-14
    boolean = true;
else
    boolean = false;
end
end

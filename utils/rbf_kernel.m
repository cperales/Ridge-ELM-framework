function omega = rbf_kernel(U, V, k)
    nb_data = size(Xtrain,1);
    if nargin == 1,
        XXh = sum(U.^2,2)*ones(1, nb_data);
        omega = XXh+XXh' - 2*(U*U');
        omega = exp(-omega./kernel_pars(1));
    else
        XXh1 = sum(U.^2,2)*ones(1,size(V,1));
        XXh2 = sum(V.^2,2)*ones(1,nb_data);
        omega = XXh1+XXh2' - 2*U*V';
        omega = exp(-omega./k);
    end
end
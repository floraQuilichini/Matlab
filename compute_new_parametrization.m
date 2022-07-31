function [tau, eta, kappa, su_nx] = compute_new_parametrization(u_n, pt)
%function to reparametrize the scalar field su. The output parameter will
%be used as parameters of the GLS descriptor
% pt can be a vector (1 by 3) or a matrix (n by 3). 
% u_n can be a vector (5 by 1)or a matrix (n by 5, or n by 5 by k in case
% of multiscale)

[l_pt, c_pt] = size(pt);
[~,~, k] = size(u_n);


if k == 1
    if l_pt == 1 || c_pt == 1  % case where p is a single point
        if l_pt>c_pt
            pt = pt';
        end

        [l_u_n, c_u_n] = size(u_n);
        if c_u_n>l_u_n
            u_n = u_n';
        end

        su_nx = @(x,y,z) [1, x, y, z, x*x+y*y+z*z]*u_n ;
        su_np = [1, pt, pt*pt']*u_n ;
        grad_su_np = u_n(2:4) + 2*u_n(5)*pt'; 
        norm_grad_su_np = sqrt(grad_su_np'*grad_su_np);

        tau = su_np;
        eta = grad_su_np/norm_grad_su_np;
        kappa = 2*u_n(5);
    else  % case where p is a matrix 
        su_nx = @(x,y,z) sum(repmat([1, x, y, z, x*x+y*y+z*z], l_pt, 1).*u_n, 2);
        su_np = sum([ones(l_pt, 1), pt, sum(pt.^2, 2)].*u_n, 2); 
        grad_su_np = sum(u_n(:, 2:4) + 2*u_n(:, 5).*pt, 2); 
        norm_grad_su_np = sqrt(sum(grad_su_np.^2, 2));

        tau = su_np;
        eta = grad_su_np./norm_grad_su_np;
        kappa = 2*u_n(:, 5);
    end

else     % multiscale case
    su_nx = @(x,y,z) sum(repmat([1, x, y, z, x*x+y*y+z*z], l_pt, 1, k).*u_n, 2);
    su_np = sum(repmat([ones(l_pt, 1), pt, sum(pt.^2, 2)], [1 1 k]).*u_n, 2); 
    grad_su_np = sum(u_n(:, 2:4, :) + 2*u_n(:, 5, :).*repmat(pt, [1 1 k]), 2); 
    norm_grad_su_np = sqrt(sum(grad_su_np.^2, 2));

    tau = su_np;
    eta = grad_su_np./norm_grad_su_np;
    kappa = 2*u_n(:, 5, :);
end

end


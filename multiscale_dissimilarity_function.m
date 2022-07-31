function multiscale_diss = multiscale_dissimilarity_function(min_scale, max_scale, step, p1, p2, Pts_1, Pts_2, Normals_1, Normals_2, varargin)
% this function compares the GLS descriptors of 2 points over multiple
% scale (ie a range of scales). The comparison makes sense only if Pts_1
% and Pts_2 lie in similar bbox size

numvararg = length(varargin);
if numvararg == 3
    [w_tau, w_kappa, w_phi] = varargin{:};
else
    w_tau = 1;
    w_kappa = 1;
    w_phi =1;
end

sum_diss = 0;
for scale=min_scale:step:max_scale  % can be speed up with parallelization
    
    % compute GLS descriptors at p1 and p2 for the current scale
    [tau1, eta1, kappa1, phi1] = compute_GLS_descriptor(p1, scale, Pts_1, Normals_1);
    GLS_p1 = [tau1, eta1, kappa1, phi1];
    [tau2, eta2, kappa2, phi2] = compute_GLS_descriptor(p2, scale, Pts_2, Normals_2);
    GLS_p2 = [tau2, eta2, kappa2, phi2];
    
    % compute simple dissimilarity
    diss = dissimilarity_function(GLS_p1, GLS_p2, w_tau, w_kappa, w_phi);
    
    % add dissimilarity
    sum_diss = sum_diss + diss;
    
end

multiscale_diss = sum_diss/(max_scale - min_scale);

end


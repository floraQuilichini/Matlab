function diss = dissimilarity_function(GLS_p1, GLS_p2, varargin)
%function used to compare GLS descriptor at 2 points
% GLS can be 1-by-6 vector (correspond to one descriptor) or n-by-6
% vector(correspond to several descriptors). In all the cases, we should
% perform descriptor to descriptor comparison and so, GLS_p1 should contain
% as many elements as GLS_p2

numvararg = length(varargin);
if numvararg == 3
    [w_tau, w_kappa, w_phi] = varargin{:};
else
    w_tau = 1;
    w_kappa = 1;
    w_phi =1;
end


% check size
[l1, c1] = size(GLS_p1);
[l2, c2] = size(GLS_p2);
if (l1 ~= l2) || (c1 ~= c2) 
    error('GLS_p1 and GLS_p2 should have the same size');
end


tau1 = GLS_p1(:, 1);
tau2 = GLS_p2(:, 1);
kappa1 = GLS_p1(:, 5);
kappa2 = GLS_p2(:, 5);
phi1 = GLS_p1(:, 6);
phi2 = GLS_p2(:, 6);
% the values GLS(i, 2:4) correspond to eta parameter. Indeed, eta is a 1-by-3
% vector

diss = w_tau*(tau1 - tau2).^2 + w_kappa*(kappa1 - kappa2).^2 + w_phi*(phi1 - phi2).^2;


end


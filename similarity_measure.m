function sim = similarity_measure(GLS_p1, GLS_p2, alpha, varargin)
%function used to compare GLS descriptor(s) at 2 points
% returns a measure of similarity between the given descriptors.
% GLS must be 1-by-6 vectors or n-by-6 matrix


numvararg = length(varargin);
if numvararg == 3
    [w_tau, w_kappa, w_phi] = varargin{:};
else
    w_tau = 1;
    w_kappa = 1;
    w_phi =1;
end

% compute dissimilarity
diss = dissimilarity_function(GLS_p1, GLS_p2, w_tau, w_kappa, w_phi);
% get similarity
sim = 1 - tanh(alpha*diss);

end


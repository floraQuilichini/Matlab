function [optimal_lag, Dsigma] = cell_lag_estimation_v2(descriptors_source, descriptors_target, nb_samples, w, alpha, min_overlap_percentage)

% descriptors are n by 3 by k matrices, where :
% - n corresponds to the number of points (we take the same n number of 
% points in source and target to compute the lag) 
% - 3 is for the number of GLS parameters( tau, kappa, phi)
% - k is the scale values (same k for scriptors_source and
% descriptors_target)
% - w is a 3 by 1 vector
% - alpha is a scalar


if size(descriptors_source, 1) ~= size(descriptors_target, 1)
    error('for scale estimation, you have to choose the same number of points in source and target');
end

nb_points = size(descriptors_source, 1);

% stack descriptors (in order to compare each source point with
        % each target point)
descriptors_source_stacked = repmat(descriptors_source, [nb_points 1 1]);
descriptors_target_stacked = repelem(descriptors_target, nb_points, ones(1, 3), ones(1, nb_samples));


% compute Dsigma for all shifts for all points combination
min_lag = floor(min_overlap_percentage*(nb_samples-1));
Dsigma = zeros(2*(nb_samples-1)-1, nb_points.^2);
    % for negative shifts
for i = 1:(nb_samples-1)-1
    diss_i = sum(repmat(w', nb_points.^2, 1, nb_samples-i).*(descriptors_source_stacked(:, :, 1:nb_samples-i)- descriptors_target_stacked(:,:, 1+i:nb_samples)).^2, 2);
    sim_i = 1 - tanh(alpha*diss_i);
    Dsigma_i = 1/(nb_samples-1 - i)*sum(sim_i, 3);
    Dsigma(i, :) = squeeze(Dsigma_i)';
end
    % for positive shifts
for i = 0:(nb_samples-1)-1
    dissi = sum(repmat(w', nb_points.^2, 1, nb_samples-i).*(descriptors_source_stacked(:, :, 1+i:nb_samples)- descriptors_target_stacked(:, :, 1:nb_samples-i)).^2, 2);
    simi = 1 - tanh(alpha*dissi);
    Dsigmai = 1/(nb_samples-1 - i)*sum(simi, 3);
    Dsigma(nb_samples-1+i, :) = squeeze(Dsigmai)';
end


% remove lags < min_lag
Dsigma = [Dsigma(1:(nb_samples-1)-1-min_lag, :); Dsigma(nb_samples-1:2*(nb_samples-1)-1-min_lag, :)];

% compute optimal lag
    % for each shift, for each point in target, find the point in source
    % that maximizes the similarity
[pairs_max_sigma, source_matching_indices] = max(reshape(Dsigma, 2*(nb_samples-1)-1-2*min_lag, nb_points, nb_points), [], 2);
pairs_max_sigma = squeeze(pairs_max_sigma);
source_matching_indices = squeeze(source_matching_indices);
    % then, compute the maximum over shifts
[max_sim, index] = max(mean(pairs_max_sigma, 2));
if index < nb_samples -1 - min_lag
    optimal_lag = -index;
else
    optimal_lag = index - (nb_samples-1-min_lag);
end




end




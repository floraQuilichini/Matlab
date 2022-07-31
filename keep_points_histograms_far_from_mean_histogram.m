function [kept_hists, u_hist, err_mean, err_std] = keep_points_histograms_far_from_mean_histogram(file_fpfh,varargin)


g = @rusu_KLDiv;
alpha = 0.8;


% read varargin
numvararg = length(varargin);
% get function name to use (max or mean)
if numvararg==0
    ref_fpfh_file = file_fpfh;
elseif numvararg==1
    ref_fpfh_file = varargin{1};
else
    error('there is only one optional parameter');     
end

%read point-histogram of the file
[h_array, nb_fpfh_points, nb_bins] = readFPFHHistogram(file_fpfh);


% remove 0-histogram (if any)
hists = vertcat(h_array(:).hy);
nb_hists = size(hists, 1);
[max_hist, max_hist_index] = max((hists==0)*ones(nb_bins, 1));
if max_hist == nb_bins
    hists(max_hist_index, :) = [];
end


% compute the mean histogram
if numvararg==0
    u_hist = mean(hists);
else
    h_ref_array = readFPFHHistogram(ref_fpfh_file);
    hists_ref = vertcat(h_ref_array(:).hy);
    u_hist = mean(hists_ref);
end

% Compute rusu Kullback-Liebler distance between the points histograms and the mean histogram 
distances = g(hists, u_hist);
err_std = std(distances);
err_mean = mean(distances);


% make matrix with distances and their related histograms indexes
matrix = [distances, (1:1:nb_hists)'];

% plot histogram
nbins = 30;
histogram(distances, nbins);


% keep histograms which have errors such as |error| > err_mean +
% alpha*err_std
sub_matrix_inf = matrix(matrix(:, 1)<err_mean - alpha*err_std, :);
sub_matrix_sup = matrix(matrix(:, 1)>err_mean + alpha*err_std, :);
kept_hists_indices = [sub_matrix_inf(:, 2); sub_matrix_sup(:, 2)];
kept_hists_indices = sortrows(kept_hists_indices);
kept_hists = hists(kept_hists_indices, :);


end


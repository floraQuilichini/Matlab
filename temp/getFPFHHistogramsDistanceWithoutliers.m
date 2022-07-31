function mean_dist = getFPFHHistogramsDistanceWithoutliers(source_file_fpfh,target_file_fpfh, symmetry_type)
% function that returns an array of histogram distances between all the
% points of the target_file_fpfh compared to all the points in the source_file_fpfh. 
% the metric distance is the Kullback-Liebler one
% The code above dot not remove outliers (a registration pair do not need
% to be symmetric)

% get function name to use (max or mean)
if strcmp(symmetry_type, 'max')
    f = @max;
elseif strcmp(symmetry_type, 'mean')
    f = @mean;
else
    error('you must choose between "mean" or "max"');
end

%read point-histogram of each file
h_array_source = readFPFHHistogram(source_file_fpfh);
h_array_target = readFPFHHistogram(target_file_fpfh);

% remove 0-histogram (if any)
hists_source = vertcat(h_array_source(:).hy);
[nb_hist_source, nb_bins] = size(hists_source);
[max_hist_source, max_hist_source_index] = max((hists_source==0)*ones(nb_bins, 1));
if max_hist_source == nb_bins
    hists_source(max_hist_source_index, :) = [];
end

hists_target = vertcat(h_array_target(:).hy);
nb_hist_target = size(hists_target, 1);
[max_hist_target, max_hist_target_index] = max((hists_target==0)*ones(nb_bins, 1));
if max_hist_target == nb_bins
    hists_target(max_hist_target_index, :) = [];
end



% Compute Kullback-Liebler symetric distance between each point of the
% target point of the target point cloud, with each point of the source
% point cloud. 
% points target are less numerousb than point source

source_to_target_match_index = zeros(1, nb_hist_target);
source_to_target_match_distance = zeros(1, nb_hist_target);
for i=1:1:nb_hist_target
    [min_d_source, index_source] = min(KLDiv(hists_source, hists_target(i, :)));
%     point_source_match_for_target = h_array_source(index).p;
%     hist_value_match_for_target = h_array_source(index).hy;
    source_to_target_match_index(i) = index_source;
    source_to_target_match_distance(i) = min_d_source;
end


mean_dist = 0;
for i=1:1:nb_hist_target
    index_source = source_to_target_match_index(i);
    [min_d_target, index_target] = min(KLDiv(hists_target, hists_source(index_source, :)));
    % symmetry is not preserved : the closest point in source from point
    % target don't need to have for closest point in target the point target
    mean_dist = mean_dist + f([min_d_target, source_to_target_match_distance(i)]);
end

mean_dist = mean_dist/nb_hist_target;


end




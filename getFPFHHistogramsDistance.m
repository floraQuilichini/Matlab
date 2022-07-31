function [mean_dist, pairs_target_source, count, nb_hist_source, nb_hist_target, nb_bins, hists_source, hists_target] = getFPFHHistogramsDistance(source_file_fpfh,target_file_fpfh, write_index_matching, distance_type, varargin)
% function that returns an array of histogram distances between all the
% points of the target_file_fpfh compared to all the points in the source_file_fpfh. 
% the source and target files must have the .txt extension
% the metric distance is the Kullback-Liebler one
% The code above remove outliers by keeping symmetric histogram pairs as
% registration pairs

flag = 0;
numvararg = length(varargin);
% get function name to use (max or mean)
if numvararg==0
    f = @max;
elseif numvararg > 1
    error('there is only one optional argument (just in case you previously choose KL distance)');
else
    symmetry_type = varargin{:};
    if strcmp(symmetry_type, 'max')
        f = @max;
    elseif strcmp(symmetry_type, 'mean')
        f = @mean;
    else
        error('you must choose between "mean" or "max"');
    end
end
    
    % get the type of distance to use
if strcmp(distance_type, 'KL')
    g = @KLDiv;
elseif strcmp(distance_type, 'L2')
    g = @L2_distance;
elseif strcmp(distance_type, 'L2_KDtree')
    g = @KDtree_hist_search;
elseif strcmp(distance_type, 'corr')
    g = @xcorr;
else
    error('you must choose between "L2" and "KL" and "L2_KDtree" (Kullback-liebler) distance');
    
end


if flag
    % keep only "interresting" points in source point cloud
    hists_source = keep_points_histograms_far_from_mean_histogram(source_file_fpfh, target_file_fpfh);
    nb_hist_source = size(hists_source, 1);
    % process target file
    [h_array_target, nb_fpfh_target_points, nb_bins] = readFPFHHistogram(target_file_fpfh);
        % remove 0-histogram (if any)
    hists_target = vertcat(h_array_target(:).hy);
    [max_hist_target, max_hist_target_index] = max((hists_target==0)*ones(nb_bins, 1));
    if max_hist_target == nb_bins
        hists_target(max_hist_target_index, :) = [];
    end
    nb_hist_target = size(hists_target, 1);
    fprintf('nb fpfh source points %d\n',nb_hist_source);
else
    
    %read point-histogram of each file
    [h_array_source, nb_fpfh_source_points, nb_bins] = readFPFHHistogram(source_file_fpfh);
    [h_array_target, nb_fpfh_target_points] = readFPFHHistogram(target_file_fpfh);

    % remove 0-histogram (if any)
    hists_source = vertcat(h_array_source(:).hy);
    [max_hist_source, max_hist_source_index] = max((hists_source==0)*ones(nb_bins, 1));
    if max_hist_source == nb_bins
        hists_source(max_hist_source_index, :) = [];
    end
    nb_hist_source = size(hists_source, 1);

    hists_target = vertcat(h_array_target(:).hy);
    [max_hist_target, max_hist_target_index] = max((hists_target==0)*ones(nb_bins, 1));
    if max_hist_target == nb_bins
        hists_target(max_hist_target_index, :) = [];
    end
    nb_hist_target = size(hists_target, 1);

end

% check which point cloud has more points. it should be the source in
% regular cases, but you could also have chosen to down-sample the source
% and have at the end less points in the source than in the target; In that
% case, we need to measure the histogram distance from source to target
reverse = 0;
hists_ref = hists_source;
hists_query = hists_target;
nb_hists_query = nb_hist_target;
% if nb_hist_target > nb_hist_source
%     hists_ref = hists_target;
%     hists_query = hists_source;
%     nb_hists_query = nb_hist_source;
%     reverse = 1;
% else
%     hists_ref = hists_source;
%     hists_query = hists_target;
%     nb_hists_query = nb_hist_target;
% end




% Compute distance (Kullback-Liebler symetric or L2) between each histogram 
% of the target point cloud, with each histogram of the source
% point cloud. 
% points target are less numerousb than point source

if strcmp(distance_type, 'L2_KDtree')
    [ref_to_query_match_index, dist] = g(hists_query, hists_ref, 'euclidean');
    ref_to_query_match_index = transpose(ref_to_query_match_index);
%     mean_dist = mean(dist);
%     query_index = (1:1:nb_hists_query);
    % cross check
    [cross_check_ref, cross_check_dist] = g(hists_ref(ref_to_query_match_index', :), hists_query, 'euclidean');
    cross_check_ref = transpose(cross_check_ref);
    bool_matrix = (cross_check_ref == (1:1:nb_hists_query));
    cross_check_ref = cross_check_ref(bool_matrix);
    ref_to_query_match_index = ref_to_query_match_index(bool_matrix);
    mean_dist = mean(cross_check_dist(bool_matrix));
    if reverse
%         cross_check = [query_index; ref_to_query_match_index];  
        cross_check = [cross_check_ref; ref_to_query_match_index];
    else
%         cross_check = [ref_to_query_match_index; query_index];   % cross-check contains source in 1) and target in 2)
        cross_check = [ref_to_query_match_index; cross_check_ref];
    end
count = size(cross_check,2);

elseif strcmp(distance_type,'corr')
    % get target points correspondances
    ref_to_query_match_index = zeros(1, size(hists_query,1));
    dists = zeros(1, size(hists_query,1));
    for i=1:1:size(hists_query,1)
        max_corr= 0;
        for j=1:1:size(hists_ref, 1)
            r = xcorr(hists_query(i,:), hists_ref(j,:), 'normalized');
            current_corr = max(r);
            if current_corr > max_corr
                max_corr = current_corr;
                ref_index = j;
                dist = 1- max_corr;
            end
        end
        ref_to_query_match_index(1, i) = ref_index;
        dists(1, i) = dist;
    end
    % cross check
    cross_check = [];
    dists_cross_check = []; 
    remaining_hists_ref = hists_ref(ref_to_query_match_index, :);
    for i=1:1:size(remaining_hists_ref,1)
        max_corr= 0;
        for j=1:1:size(hists_query, 1)
            r = xcorr(remaining_hists_ref(i,:), hists_query(j,:), 'normalized');
            current_corr = max(r);
            if current_corr > max_corr
                max_corr = current_corr;
                query_index = j;
                
            end
        end
        if query_index == i
            cross_check(:, end+1) = [ref_to_query_match_index(i); i]; %  cross-check contains source in 1) and target in 2)
            dists_cross_check(1, end+1) = dists(i);
        end
    end
    
 if reverse
    cross_check = flip(cross_check);
 end
 
count = size(cross_check,2);  
mean_dist = mean(dists_cross_check);

else
    ref_to_query_match_index = zeros(1, nb_hists_query);
    ref_to_query_match_distance = zeros(1, nb_hists_query);
    for i=1:1:nb_hists_query
        [min_d_ref, index_ref] = min(g(hists_ref, hists_query(i, :)));
    %     point_source_match_for_target = h_array_source(index).p;
    %     hist_value_match_for_target = h_array_source(index).hy;
        ref_to_query_match_index(i) = index_ref;
        ref_to_query_match_distance(i) = min_d_ref;
    end

%     if strcmp(distance_type, 'L2')
%         mean_dist = mean(source_to_target_match_distance);
%         count = nb_hist_target;
%         target_index = (1:1:nb_hist_target);
%         cross_check = [source_to_target_match_index; target_index];
%     elseif strcmp(distance_type, 'KL')
            % Kullback-Liebler symmetric
            
        % symetric operation
    mean_dist = 0;
    count = 0;
    cross_check = zeros(2, nb_hists_query);
    for i=1:1:nb_hists_query
        index_ref = ref_to_query_match_index(i);
        [min_d_query, index_query] = min(g(hists_query, hists_ref(index_ref, :)));
    %     point_source_match_for_source = h_array_target(index).p;
    %     hist_value_match_for_source = h_array_target(index).hy;
        if index_query == i
            % symmetry is preserved : the closest point in source from point
            % target has for closest point in target the point target
            count = count + 1;
            cross_check(:, count) = [index_ref; index_query]; 
            mean_dist = mean_dist + f([min_d_query, ref_to_query_match_distance(i)]);
        end
    end
    cross_check = cross_check(:,any(cross_check)); % remove 0 un1used elements  
    mean_dist = mean_dist/count;
%     end
    
    if reverse
        cross_check = [cross_check(2, :); cross_check(1, :)];
    end

end

% write matching indexes in fpfh binary file
display(write_index_matching)
if write_index_matching 
    cross_check = sortrows(cross_check')'; % in FGR tuple test, indices are sorted along the i value (source value). We don't have to sort them here, but it will make debugging easier
    cross_check = cross_check - ones(size(cross_check)); % index in FGR tuple test begins at 0 (and not at 1)
    % source file
    [source_dir, source_name, ~] = fileparts(source_file_fpfh);
    fpfh_binary_source_file = fullfile(source_dir, strcat(erase(source_name, '_fpfh'), '.bin'));
    fprintf('%d\n', count);
    writeMatchingInFPFHFile(fpfh_binary_source_file, count);
    writeMatchingInFPFHFile(fpfh_binary_source_file, cross_check);
    % target file
    [target_dir, target_name, ~] = fileparts(target_file_fpfh);
    fpfh_binary_target_file = fullfile(target_dir, strcat(erase(target_name, '_fpfh'), '.bin'));
    writeMatchingInFPFHFile(fpfh_binary_target_file, count);
    writeMatchingInFPFHFile(fpfh_binary_target_file, cross_check);
    cross_check = cross_check + ones(size(cross_check));
end

pairs_target_source = [cross_check(2, :); cross_check(1, :)]; % in matlab, indexes begin at 1 (this variable is supposed to be given to the visualizeFPFHPoints function)


end


function k_farthest_points = pick_k_farthest_points_bis(points, first_point, k, varargin)
% points : n-by-3 array
% first_point : 1-by-3 vector
% k : int
% varargin : if we want to give the initial k starting points to the algorithm and not
% take them randomly

nb_points = size(points, 1);
point_indices = (1:1:nb_points)';

numvararg = length(varargin);
if (numvararg ==1)
    use_initial_points = 1; 
    k_initial_points = varargin{:};
    k_indices = point_indices(ismember(points, k_initial_points, "rows"))';
else
    use_initial_points = 0; 
end

% get first point index
Li = ismember(points, first_point, 'rows');
index_first_point = point_indices(Li);
if ~use_initial_points
    % get k other points
    k_indices = randperm(nb_points, k);
    while (ismember(index_first_point, k_indices))
        k_indices = randperm(nb_points, k);
    end
end
k_farthest_points = points(k_indices, :);
k_farthest_points(end+1, :) = first_point;

% compute distance between points
l2_dists_points_to_all_points = zeros(k+1, k+1);
for i=1:1:k+1
    l2_dists_points_to_all_points(:, i) = sqrt(sum((k_farthest_points - repmat(k_farthest_points(i, :), k+1, 1)).^(2), 2));
end

dists_max_points_to_all_points = sum(l2_dists_points_to_all_points - std(l2_dists_points_to_all_points));
remaining_points = points;
%remaining_points([k_indices, index_first_point], :) = [];
% get correct k farthest points
for i=1:1:size(remaining_points, 1)
    query_point = remaining_points(i, :);
    % compute closest point in (k+1) selected points from query point
    l2_dists_query_to_all = sqrt(sum((k_farthest_points - repmat(query_point, k+1, 1)).^(2), 2));
    [~, index_min] = min(l2_dists_query_to_all(1:end-1));
    % check if distances with other points is greater than closest point
    % with others
    l2_dists_query_to_all(index_min) = [];
    l2_dist_query_to_all_points = sum(l2_dists_query_to_all - std(l2_dists_query_to_all));
    if (l2_dist_query_to_all_points > dists_max_points_to_all_points(index_min))
        k_farthest_points(index_min, :) = query_point;
        for j=1:1:k+1
            dists_j_to_all = sqrt(sum((k_farthest_points - repmat(k_farthest_points(j, :), k+1, 1)).^(2), 2));
            dists_max_points_to_all_points(j) = sum(dists_j_to_all - std(dists_j_to_all));
        end
    end

end


end



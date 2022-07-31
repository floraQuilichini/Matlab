function bw_closed = join_boundaries(im_bw, stacked_boundaries, additional_ending_leaves, varargin)

switch length(varargin)
    case 0
        max_dist = 5;
    case 1 
        max_dist = varargin{:};
    otherwise
        error('wrong number of arguments');
end
        
    

bw_closed = im_bw;
sz = [size(im_bw, 1), size(im_bw, 2)];
endings = zeros(1, 2*length(stacked_boundaries)+ length(additional_ending_leaves));
for i=1:2:2*length(stacked_boundaries)
    endings(i) = stacked_boundaries{1, round(i/2)}.leaf_init;
    endings(i+1) = stacked_boundaries{1, round(i/2)}.leaf_end;
end
endings(2*length(stacked_boundaries)+1:end) = additional_ending_leaves;
endings = unique(endings);

for i=1:length(stacked_boundaries)
    list_extremities = [stacked_boundaries{1, i}.leaf_init , stacked_boundaries{1, i}.leaf_end];
    [dists, repeated_other_px, repeated_list_extremities] = compute_distance_from_other_lists(list_extremities, endings, im_bw);
    repeated_other_px_x = repeated_other_px(:, 1);
    repeated_other_px_y = repeated_other_px(:, 2);
    repeated_other_px_x(dists <= sqrt(2) | dists > max_dist) = [];
    repeated_other_px_y(dists <= sqrt(2) | dists > max_dist) = [];
    if ~ isempty(repeated_other_px_x)
        repeated_list_extremities(dists <= sqrt(2) | dists > max_dist) = [];
        closest_points = [repeated_other_px_x, repeated_other_px_y];
        for k = 1:length(repeated_list_extremities)
            [row, col] = ind2sub(sz, repeated_list_extremities(k));
            bw_closed = linept(bw_closed, row, col, closest_points(k, 1), closest_points(k,2));
        end
    end
end

end


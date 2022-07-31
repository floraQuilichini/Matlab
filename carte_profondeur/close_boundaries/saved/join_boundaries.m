function bw_closed = join_boundaries(im_bw, stacked_boundaries, additional_ending_leaves, varargin)

switch length(varargin)
    case 0
        max_dist = 2*sqrt(2);
        min_dist = sqrt(2);
    case 1 
        max_dist = varargin{:};
        min_dist = 0;
    case 2
        max_dist = varargin{1};
        min_dist = varargin{2};
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


while length(stacked_boundaries)>1
    
    i=1;
    while i< length(stacked_boundaries)
        list_extremities = [stacked_boundaries{1, i}.leaf_init , stacked_boundaries{1, i}.leaf_end];
        [dists, repeated_other_px, repeated_list_extremities] = compute_distance_from_other_lists(list_extremities, endings, im_bw);
        repeated_other_px_x = repeated_other_px(:, 1);
        repeated_other_px_y = repeated_other_px(:, 2);
        repeated_other_px_x(dists <= min_dist | dists > max_dist) = [];
        repeated_other_px_y(dists <= min_dist | dists > max_dist) = [];
        if ~ isempty(repeated_other_px_x)
            repeated_list_extremities(dists <= min_dist | dists > max_dist) = [];
            closest_points = [repeated_other_px_x, repeated_other_px_y];
            for k = 1:length(repeated_list_extremities)
                [row, col] = ind2sub(sz, repeated_list_extremities(k));
                bw_closed = linept(bw_closed, row, col, closest_points(k, 1), closest_points(k,2));
                [stacked_boundaries, additional_ending_leaves] = extend_boundaries(stacked_boundaries, additional_ending_leaves,  repeated_list_extremities(k), sub2ind(sz, closest_points(k, 1), closest_points(k,2)));
            end
           if stacked_boundaries{1, i}.leaf_init == stacked_boundaries{1, i}.leaf_end
               additional_ending_leaves(end+1) = stacked_boundaries{1, i}.leaf_end;
               stacked_boundaries(i) = [];
           else 
               if (ismember(stacked_boundaries{1, i}.leaf_init, additional_ending_leaves) && ismember(stacked_boundaries{1, i}.leaf_end, additional_ending_leaves))
                    stacked_boundaries(i) = [];
               end
           end
        else
            i = i+1;
        end

    end
    min_dist = max_dist;
    max_dist = max_dist +sqrt(2);
end

end


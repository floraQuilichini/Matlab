function regions = region_growing(im_boundaries)

[l, c] = size(im_boundaries);
remaining_indices = (1:1:l*c);
regions = {};

while(~isempty(remaining_indices))
    % pick a good index to initialize the region
    rand_i = randi(size(remaining_indices, 2), 1);
    while(im_boundaries(rand_i) ==1 && ~isempty(remaining_indices))
        remaining_indices(remaining_indices == rand_i) = [];
        rand_i = randi(size(remaining_indices, 2), 1);
    end
    % region growing
    if isempty(remaining_indices)
        break;
    else
        % initialize the region
        new_index = remaining_indices(rand_i);
        [current_region, current_border, remaining_indices] = initialize_region(new_index, remaining_indices);
        flag = 1;
        % grow the region
        while(flag)
            [extended_region, current_border, remaining_indices] = extend_neighbours(im_boundaries, current_region, current_border, remaining_indices);
            if length(extended_region) == length(current_region)
                regions{1, end+1} = current_region;
                flag = 0;
            else
                current_region = extended_region;
            end
        end
    end
end
end


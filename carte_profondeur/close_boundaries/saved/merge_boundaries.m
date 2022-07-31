function stacked_boundaries = merge_boundaries(new_bound, stacked_boundaries)

l = length(stacked_boundaries);
for i = 1:l
    leaf_init = stacked_boundaries{1,i}.leaf_init;
    leaf_end = stacked_boundaries{1,i}.leaf_end;
    if new_bound.leaf_end == leaf_init
        merged_list = [new_bound.list(1:end-1), stacked_boundaries{1, i}.list];
        stacked_boundaries{1,i}.list = merged_list;
        stacked_boundaries{1, i}.leaf_init = new_bound.leaf_init;
        stacked_boundaries{1, i}.sec = new_bound.sec;
        break;
    end

    if new_bound.leaf_end == leaf_end
        merged_list = [stacked_boundaries{1, i}.list, flip(new_bound.list(1:end-1))];
        stacked_boundaries{1,i}.list = merged_list;
        stacked_boundaries{1, i}.leaf_end = new_bound.leaf_init;
        stacked_boundaries{1, i}.prev = new_bound.sec;
        break;
    end
    
end
end


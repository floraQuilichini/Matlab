function [stacked_boundaries, additional_ending_leaves] = get_boundaries(im_bw)
indexes = find(im_bw);
stacked_boundaries = {};
additional_ending_leaves = [];
while(~isempty(indexes))
    rand_int =  randi([1 length(indexes)],1);
    index = indexes(rand_int);
    new_bound.list = [];
    new_bound.prev = index;
    new_bound.leaf_init = index;
    new_bound.list(end+1) = index;
    indexes(indexes==index) = [];
    flag_end_of_chain = 0;
    current_ind = index;
    while(has_neighbour(current_ind, im_bw))
        nb = has_neighbour(current_ind, im_bw);
        switch nb
            case 1
                if length(new_bound.list)==1
                    [~, neighbours_ind] = get_neighbours(index, im_bw);
                    new_bound.list(end+1) = neighbours_ind;
                    indexes(indexes == neighbours_ind) = [];
                    current_ind = neighbours_ind;
                    new_bound.prev = index;               
                else
                    new_bound.leaf_end = current_ind;
                    flag_end_of_chain = 1;
                    break
                end
                    
            case 2
                [~, neighbours_ind] = get_neighbours(current_ind, im_bw);
                if length(new_bound.list)==1
                    new_bound.list(end+1) = neighbours_ind(1);
                    indexes(indexes == neighbours_ind(1)) = [];
                    current_ind = neighbours_ind(1);
                    new_bound.prev = index;  
                else
                    next_ind = get_next_index(neighbours_ind, new_bound.prev);
                    if isempty(next_ind)
                        new_bound.leaf_end = current_ind;
                        flag_end_of_chain = 1;
                        break;
                    end
                    new_bound.list(end+1) = next_ind;
                    indexes(indexes == next_ind) = [];
                    new_bound.prev = current_ind;
                    current_ind = next_ind;
                end

            otherwise
                [~, neighbours_ind] = get_neighbours(current_ind, im_bw);
                next_ind = get_next_index(neighbours_ind, new_bound.prev);
                if isempty(next_ind)
                    new_bound.leaf_end = current_ind;
                    flag_end_of_chain = 1;
                    break;
                else
                    new_bound.list(end+1) = next_ind(1);
                    indexes(indexes == next_ind(1)) = [];
                    new_bound.prev = [current_ind, next_ind(2:end)];
                    additional_ending_leaves = [additional_ending_leaves, current_ind, next_ind(2:end)];
                    current_ind = next_ind(1);
                end
        end
        
        if is_leaf(current_ind, stacked_boundaries)
            new_bound.leaf_end = current_ind;
            stacked_boundaries = merge_boundaries(new_bound, stacked_boundaries);
            flag_end_of_chain = 2;
            break
        end
        
        if is_leaf(current_ind,  additional_ending_leaves)
            new_bound.leaf_end = current_ind;
            flag_end_of_chain = 1;
            break
        end
    end
    if (flag_end_of_chain == 1)
        stacked_boundaries{1,end+1} = new_bound;
    end        
    
end 
end

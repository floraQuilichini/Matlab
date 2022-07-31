function b = is_leaf(current_ind, list_boundaries)
if isempty(list_boundaries)
    b = 0;
else
    l = length(list_boundaries);
    b = 0;
    if isa(list_boundaries,'cell')
        for i=1:l
            leaf_init = list_boundaries{1, i}.leaf_init;
            leaf_end = list_boundaries{1, i}.leaf_end;
            if current_ind == leaf_init || current_ind == leaf_end
                b = 1;
                break;
            end
        end
    else
        for i=1:l
            leaf_end = list_boundaries(i);
            if current_ind == leaf_end
                b = 1;
                break;
            end
        end    
    end
end
end


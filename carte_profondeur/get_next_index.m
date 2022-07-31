function  next_ind = get_next_index(neighbours_ind, forbidden_indices)
next_ind = neighbours_ind;
for i=1:length(forbidden_indices)
    next_ind(next_ind ==forbidden_indices(i)) = [];
end

end


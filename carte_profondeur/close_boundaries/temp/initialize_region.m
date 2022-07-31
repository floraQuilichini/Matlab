function [current_region, current_border, remaining_indices] = initialize_region(new_index, remaining_indices)
 current_region = new_index;
 current_border= new_index;
 remaining_indices(remaining_indices == new_index) = [];
end


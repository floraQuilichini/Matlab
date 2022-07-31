function [extended_region, new_border, remaining_indices] = extend_neighbours(im_boundaries, current_region, current_border, remaining_indices)

extended_region = current_region;
new_border = [];
for k=1:1:length(current_border)
    ind = current_border(k);
    [ind_i, ind_j] = ind2sub(size(im_boundaries), ind);
    number = 0;
    if ind_i == 1
        number = number +1;
    end
    if ind_j == 1
        number = number +2;
    end
    if ind_i == size(im_boundaries, 1)
        number = number +10;
    end
    if ind_j == size(im_boundaries, 2)
        number = number +20;
    end
    
    switch  number
        case 1
            i_init = 0;
            j_init = -1;
            i_end = 1;
            j_end = 1;
        case 2
            i_init = -1;
            j_init = 0;
            i_end = 1;
            j_end = 1;
        case 3
            i_init = 0;
            j_init = 0;
            i_end = 1;
            j_end = 1;
        case 10
            i_init = -1;
            j_init = -1;
            i_end = 0;
            j_end = 1;
        case 12
            i_init = -1;
            j_init = 0;
            i_end = 0;
            j_end = 1;
        case 20
            i_init = -1;
            j_init = -1;
            i_end = 1;
            j_end = 0;
        case 21
            i_init = 0;
            j_init = -1;
            i_end = 1;
            j_end = 0;
        case 30
            i_init = -1;
            j_init = -1;
            i_end = 0;
            j_end = 0;
        otherwise
            i_init = -1;
            j_init = -1;
            i_end = 1;
            j_end = 1;
    end
    
    for i=i_init:1:i_end
        for j=j_init:1:j_end
            if (i == 0) && (j ==0)
                break;
            else
                n_ind = sub2ind(size(im_boundaries), ind_i+i, ind_j +j);
                if im_boundaries(ind_i+i, ind_j +j)==1
                    new_border(1, end+1) = ind;
                else
                    new_border(1, end+1) = n_ind;
                    if remaining_indices(remaining_indices == n_ind)
                        extended_region(1, end+1) = n_ind;
                    end
                end
                remaining_indices(remaining_indices == n_ind) = [];
            end
        end
    end
end
new_border = unique(new_border);
end



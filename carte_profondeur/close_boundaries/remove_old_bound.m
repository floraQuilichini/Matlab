function stacked_boundaries = remove_old_bound(stacked_boundaries, ext_to_remove)

switch size(ext_to_remove, 2)
    case 0
        disp('no extremity');
    case 1
        disp('only one extremity');
    case 2
        for k=1:length(stacked_boundaries)
            if stacked_boundaries{1, k}.leaf_init == ext_to_remove(1) && stacked_boundaries{1, k}.leaf_end == ext_to_remove(2)
                stacked_boundaries(k) = [];
                break;
            end
            if stacked_boundaries{1, k}.leaf_end == ext_to_remove(1) && stacked_boundaries{1, k}.leaf_init == ext_to_remove(2)
                stacked_boundaries(k) = [];
                break;
            end
        end
    otherwise
        error('error');
end

end


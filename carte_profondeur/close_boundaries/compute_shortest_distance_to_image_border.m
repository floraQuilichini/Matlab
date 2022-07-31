function [dist, border_index] = compute_shortest_distance_to_image_border(sz, index_query)

[r, c] = ind2sub(sz, index_query);
dh1 = c; 
dh2 = sz(2) - c;
dv1 = r;
dv2 = sz(1) - r;

[dist, ind] = min([dh1, dh2, dv1, dv2]);
switch ind
    case 1
        border_index = sub2ind(sz, r, 1);
    case 2
        border_index = sub2ind(sz, r, sz(2));
    case 3
        border_index = sub2ind(sz, 1, c);
    otherwise
        border_index = sub2ind(sz, sz(1), c);
end
        

end


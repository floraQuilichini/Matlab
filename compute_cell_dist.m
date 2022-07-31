function [dist, selected_points] = compute_cell_dist(Pts,Pt_query, indices)

% pts is a 3 by n matrix and Pt_query a 3 by 1 vector

selected_points = Pts(:, indices)';
dist = sqrt(sum((selected_points - Pt_query').^(2), 2));


end


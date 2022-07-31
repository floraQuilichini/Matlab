function [outputPoints, dist, indexes] = radius_search(Pts, Pt_query, radius)
% we suppose Pts is a n by 3 matrix and Pt_query a 1 by 3 vector 


nb_points = size(Pts, 1);

% compute distance to Pt_query, for all Pts
d = sqrt(sum((Pts - repmat(Pt_query, nb_points, 1)).^(2), 2));
% sort Points by distance to Pts_query
d_Pts = [d, Pts];
[d_Pts, indexes] = sortrows(d_Pts);
% compute output points
i_d_Pts = [indexes, d_Pts];
i_d_outputPoints = i_d_Pts(i_d_Pts(:, 2) < radius, :);
outputPoints = i_d_outputPoints(:, 3:end);
% compute dist
dist = i_d_outputPoints(:, 2);
% compute indexes
indexes = i_d_outputPoints(:, 1);


end


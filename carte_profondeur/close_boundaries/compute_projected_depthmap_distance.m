function [dist] = compute_projected_depthmap_distance(depthmap_ref,depthmap_query)
% project the depthmaps in 3D space and compute euclidian distance between
% the projected points

%[pc_ref, r_indices_ref, s_indices_ref] = project_depthmap(depthmap_ref, [640, 480], [319.5, 239.5], 525.0, 0.0,1000.0); 
%[pc_query, r_indices_query, s_indices_query] = project_depthmap(depthmap_query, [640, 480], [319.5, 239.5], 525.0, 0.0,1000.0);

[pc_ref, r_indices_ref, s_indices_ref] = project_depthmap(depthmap_ref, [128, 128], [319.5, 239.5], 525.0, 0.0,1000.0); 
[pc_query, r_indices_query, s_indices_query] = project_depthmap(depthmap_query, [128, 128], [319.5, 239.5], 525.0, 0.0,1000.0);

Liq = ismember(r_indices_query, s_indices_ref)';
Lir = ismember(r_indices_ref, s_indices_query)';


M = repmat(Liq, 1, 3);
N = repmat(Lir, 1, 3);
M_ = repmat(~Liq, 1, 3);
N_ = repmat(~Lir, 1, 3);
points_query = pc_query.Location;
points_ref = pc_ref.Location;
dist = sum(sqrt(sum( reshape(points_query(M), [], 3).^(2), 2))) + sum(sqrt(sum( reshape(points_ref(N), [], 3).^(2), 2)));
dist = dist + sum(sqrt(sum( (reshape(points_query(M_), [], 3) - reshape(points_ref(N_), [], 3)).^(2), 2)));

end
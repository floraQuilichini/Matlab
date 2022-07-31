function [mean_edge_length, std_edge_length] = compute_edges_statistics(pts, faces)
%return the statitics of mesh edges
% pts are points of the mesh (array of n-by-3 of the point 3D-coordinates)
% faces is an n-by-3 array that contains the point index of each triangular
% face of the mesh

% construct array of existing edges
edges = [faces(:, 1:2); faces(:, 2:3); [faces(:, 1), faces(:, 3)]];
    % edge indices are sorted in ascending order
edges = sort(edges,2);
    % remove edges dupplicates
edges = unique(edges, 'rows');
% get edge lengths
edges_length = sqrt(sum((pts(edges(:, 1),:)- pts(edges(:, 2),:)).^(2), 2));
mean_edge_length = mean(edges_length);
std_edge_length = std(edges_length);

end


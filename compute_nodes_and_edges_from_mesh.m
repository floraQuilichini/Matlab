function [nodes, segments] = compute_nodes_and_edges_from_mesh(faces, pts)

vertex_ids = (1:1:size(pts,1))';
% get nodes
nodes = [vertex_ids, pts];
% get segments
    % edges = [faces(1, 1:2); faces(1, 2:3); [faces(1,1), faces(1,3)]];
    % for i=2:1:size(faces,1)
    %     new_edges = [faces(i, 1:2); faces(i, 2:3); [faces(i,1), faces(i,3)]];
    %     for j=1:1:3
    %         if ~(ismember(new_edges(j,:), edges, 'rows') || ismember(flip(new_edges(j, :)),edges, 'rows')) 
    %             edges(end+1, :) = new_edges(j,:);
    %         end
    %     end
    % end
edges = [faces(:,1:2); faces(:, 2:3); [faces(:, 1), faces(:, 3)]];
edges = unique(edges, "rows");
permuted_edges = flip(edges, 2);
edges(ismember(edges, permuted_edges, "rows"), :) = [];
edges_ids = (1:1:size(edges,1))';
segments = [edges_ids, edges];

end


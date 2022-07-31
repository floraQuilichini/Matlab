function [min_dist] = dijkstra_v2(vertices, edges, id_start, id_end, mean_edge_length, std_edge_length)
% vertices(k,:) = [x y z]
% edges(k, :) = [vertex_i_id vertex_j_id]

dists_from_id_start = realmax*ones(1, size(vertices, 1));
dists_from_id_start(id_start) = 0;
visited_edges = zeros(size(edges, 1), 1);
processed_vertex_ids = zeros(1, size(vertices,1));
stop_flag =0;
iter = 1;
max_iter = size(edges, 1);
while (~stop_flag)
    % get current id
    [~, current_id] = min(dists_from_id_start(~processed_vertex_ids));
    % get neighbors vertices of current vertex
    adjacent_mat = ismember(edges, current_id);
    adjacent_vertices_ids = edges(flip(adjacent_mat, 2));
    % mark edges as visited
    visited_edges(adjacent_mat(:, 1) | adjacent_mat(:, 2)) = 1;
    % compute distances from current vertex
    dists_neighbors = sqrt(sum((vertices(adjacent_vertices_ids, :) - vertices(current_id, :)).^2, 2))';
    % update distances table
    update_matrix = (dists_from_id_start(adjacent_vertices_ids) > dists_neighbors);
    dists_from_id_start(adjacent_vertices_ids(update_matrix)) = dists_neighbors(update_matrix) + dists_from_id_start(current_id);
    % update processed vertices ids
    processed_vertex_ids(current_id) = 1;
    % check if ending id has been reached
    if (ismember(id_end, adjacent_vertices_ids) && max_iter == size(edges,1))
        max_iter = iter + floor(2*iter*std_edge_length/abs(mean_edge_length - std_edge_length));
    end
    % update flag
    stop_flag = ~ismember(0, visited_edges) | iter > max_iter;
    % increment iter
    iter = iter +1;
end

min_dist = dists_from_id_start(id_end);

end


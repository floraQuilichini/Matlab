function target_source_matchings_checked = geodesic_distance_check_matching_pairs(faces_s, pts_s, faces_t, pts_t, keypoints_s, keypoints_t, target_source_matchings , nb_nearest_neighbors, distance_error, threshold)

% sort matchings along target index
target_source_matchings_sorted = sortrows(target_source_matchings);

% get the nearest neighbor index of each target keypoint
 keypoints_with_match_t = keypoints_t(target_source_matchings_sorted(:, 1),:);
 keypoints_with_match_s = keypoints_s(target_source_matchings_sorted(:, 2),:);
 Idx_t = knnsearch(keypoints_with_match_t, keypoints_with_match_t,'K', nb_nearest_neighbors+1);
 
 % compute nodes and edges
[nodes_s, segments_s] = compute_nodes_and_edges_from_mesh(faces_s, pts_s);
id_s = knnsearch(pts_s, keypoints_with_match_s);
[nodes_t, segments_t] = compute_nodes_and_edges_from_mesh(faces_t, pts_t);
id_t = knnsearch(pts_t, keypoints_with_match_t);

% compute mean edge length and std edge length
[mean_edge_length_s, std_edge_length_s] = compute_edges_statistics(pts_s, faces_s);
[mean_edge_length_t, std_edge_length_t] = compute_edges_statistics(pts_t, faces_t);
 
 % compute geodesic distance from each target neighbor to each target neighbor
 Dist_neighbors_to_neighbors_t = zeros(size(keypoints_with_match_t, 1), nb_nearest_neighbors+1, nb_nearest_neighbors+1 );
 for i = 1:1:size(keypoints_with_match_t,1)
     for j = 1:1:nb_nearest_neighbors+1
         start_id = id_t(Idx_t(i, j));
         for k = 1:1:nb_nearest_neighbors+1
             finish_id = id_t(Idx_t(i,k));
             Dist_neighbors_to_neighbors_t(i, j ,k) = dijkstra_v2(nodes_t(:, 2:end),segments_t(:,2:end),start_id,finish_id, mean_edge_length_t, std_edge_length_t);
         end
     end
 end
 % get mean neighbor distance of each target keypoint
 MeanDist_neighbors_to_neighbors_t = sum(sum(Dist_neighbors_to_neighbors_t, 3), 2)/(nb_nearest_neighbors*(nb_nearest_neighbors + 1));

% get distances of neighbor source matchings  from each source matching keypoint
 Dist_neighbors_to_keypoint_s = zeros(size(keypoints_with_match_t, 1), nb_nearest_neighbors+1);
 for i = 1:1:size(keypoints_with_match_t,1)
     start_id = id_s(Idx_t(i, 1));
     for j = 1:1:nb_nearest_neighbors +1
         finish_id = id_s(Idx_t(i, j));
         Dist_neighbors_to_keypoint_s(i, j) = dijkstra_v2(nodes_s(:, 2:end),segments_s(:, 2:end),start_id,finish_id, mean_edge_length_s, std_edge_length_s);
     end
 end
 % check if neighbor distances are close enough from keypoint target neighbors mean distance.
% If so, the source keypoint is an inlier. If not, it's an outlier
 matrix_ratio = Dist_neighbors_to_keypoint_s ./ repmat(MeanDist_neighbors_to_neighbors_t, 1, nb_nearest_neighbors +1);
 matrix_ratio(isnan(matrix_ratio)) = 1;
checked_neighbors = matrix_ratio < distance_error;
 count = sum(checked_neighbors, 2);
inliers_indices_target = target_source_matchings_sorted(Idx_t(count >= threshold, 1), 1); 
inliers_indices_source = target_source_matchings_sorted(Idx_t(count >= threshold, 1), 2);
target_source_matchings_checked = [inliers_indices_target, inliers_indices_source];


end


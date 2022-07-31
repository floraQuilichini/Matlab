function target_source_matchings_checked = geodesic_distance_check_matching_pairs_bis(faces_s, pts_s, faces_t, pts_t, keypoints_s, keypoints_t, target_source_matchings , nb_nearest_neighbors, distance_error, threshold)

global geodesic_library;                
geodesic_library = 'geodesic_debug';      %"release" is faster and "debug" does additional checks

% sort matchings along target index
target_source_matchings_sorted = sortrows(target_source_matchings);
nb_keypoints_with_match =  size(target_source_matchings_sorted, 1);

% get the nearest neighbor index of each target keypoint
 keypoints_with_match_t = keypoints_t(target_source_matchings_sorted(:, 1),:);
 Idx_t = knnsearch(keypoints_with_match_t, keypoints_with_match_t,'K', nb_nearest_neighbors+1);
 Idx_s = reshape(target_source_matchings_sorted(Idx_t(:), 2), nb_keypoints_with_match, nb_nearest_neighbors +1);

%generate first mesh
analysis{1}.N = nb_keypoints_with_match;         
analysis{1}.vertices = pts_t;
analysis{1}.faces = faces_t;
%generate second mesh
analysis{2}.vertices = pts_s;
analysis{2}.faces = faces_s; 
analysis{2}.N = nb_keypoints_with_match; 
% get ids of starting and ending points
target_ids = reshape(knnsearch(pts_t, keypoints_t(target_source_matchings_sorted(Idx_t(:), 1),:),'K', 1), nb_keypoints_with_match, nb_nearest_neighbors +1);
source_ids = reshape(knnsearch(pts_s, keypoints_s(Idx_s(:),:),'K', 1), nb_keypoints_with_match, nb_nearest_neighbors +1);
% extract starting points ids
analysis{1}.start_ids = target_ids(:,1);
analysis{2}.start_ids = source_ids(:,1);
% extract ending points
analysis{1}.end_ids = target_ids(:,2:end);
analysis{2}.end_ids = source_ids(:,2:end);


for k = 1:length(analysis)                %generate two meshes and corresponding algorithms
    analysis{k}.mesh = geodesic_new_mesh(analysis{k}.vertices, analysis{k}.faces);         %initilize new mesh
    if k==1
        analysis{k}.algorithm = geodesic_new_algorithm(analysis{k}.mesh, 'dijkstra');   %initialize dijkstra algorithm 
    else
        analysis{k}.algorithm = geodesic_new_algorithm(analysis{k}.mesh, 'dijkstra');   %initialize dijkstra algorithm 
    end
    
%     % plot meshes
%     trisurf(analysis{i}.faces,analysis{i}.vertices(:,1),analysis{i}.vertices(:,2),analysis{i}.vertices(:,3),...
%         'FaceColor', 'w', 'EdgeColor', 'k', 'FaceAlpha', 0.99);       %plot the mesh
%     hold on;
end

% compute geodesic distance from each point to its neighbors 
for k = 1:length(analysis)
    cmap = hsv(max(analysis{k}.N * nb_nearest_neighbors,1)); 
    dists{k} = zeros(analysis{k}.N , nb_nearest_neighbors);
    % get starting ids
    start_ids = analysis{k}.start_ids;
    % get ending ids
    end_ids = analysis{k}.end_ids;

    for i = 1:analysis{k}.N
        vertex_start_id = start_ids(i);                      %put a single source
        source_point = {geodesic_create_surface_point('vertex',vertex_start_id, analysis{k}.vertices(vertex_start_id,:))};
        geodesic_propagate(analysis{k}.algorithm, source_point);   %propagation stage of the algorithm 

        for j = 1:nb_nearest_neighbors
            vertex_stop_id = end_ids(i, j);           %put destination
            destination = geodesic_create_surface_point('vertex',vertex_stop_id, analysis{k}.vertices(vertex_stop_id,:));
            path = geodesic_trace_back(analysis{k}.algorithm, destination); %find a shortest path from source to destination
            [x,y,z] = extract_coordinates_from_path(path);
            path_length = sum(sqrt(diff(x).^2 + diff(y).^2 + diff(z).^2));            %length of the path
            dists{k}(i, j) = path_length;

    %         %plot path
    %         [x,y,z] = extract_coordinates_from_path(path);
    %         plot3(x,y,z,'Color',cmap((i-1)*nb_keypoints_t + j,:),'LineWidth',2);    %plot a sinlge path for this algorithm
        end 
    end
    
end

% get mean neighbor distance of each target keypoint
 MeanDist_point_to_neighbors_t = sum(dists{1}, 2)/nb_nearest_neighbors;
 
 % check if source neighbor distances are close enough from keypoint target neighbors mean distance.
% If so, the source keypoint is an inlier. If not, it's an outlier
 matrix_ratio = dists{2} ./ repmat(MeanDist_point_to_neighbors_t, 1, nb_nearest_neighbors);
 matrix_ratio(isnan(matrix_ratio)) = 1;
checked_neighbors = matrix_ratio < distance_error;
 count = sum(checked_neighbors, 2);
inliers_indices_target = target_source_matchings_sorted(Idx_t(count >= threshold, 1), 1); 
inliers_indices_source = target_source_matchings_sorted(Idx_t(count >= threshold, 1), 2);
target_source_matchings_checked = [inliers_indices_target, inliers_indices_source];



geodesic_delete;

end




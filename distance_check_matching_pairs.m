function target_source_matchings_checked = distance_check_matching_pairs(keypoints_s, keypoints_t, target_source_matchings , nb_nearest_neighbors, sr1, sr2, threshold)
% sr1 and sr2 are the similarity ratios numbers


% sort matchings along target index
target_source_matchings_sorted = sortrows(target_source_matchings);

% get the nearest neighbor index of each target keypoint
 Idx_t = knnsearch(keypoints_t, keypoints_t,'K', nb_nearest_neighbors+1);
 
 % compute distance from each source neighbor to each source neighbor
 Dist_neighbors_to_neighbors_t = zeros(size(keypoints_t, 1), nb_nearest_neighbors+1, nb_nearest_neighbors+1 );
 for n = 1:1:size(keypoints_t,1)
     Dist_neighbors_to_neighbors_t(n, : ,:) = reshape(sqrt(sum((repmat(keypoints_t(Idx_t(n, :), :), nb_nearest_neighbors+1, 1)- repelem(keypoints_t(Idx_t(n, :), :), nb_nearest_neighbors + 1,  1)).^2, 2)), [nb_nearest_neighbors+1, nb_nearest_neighbors+1]);
 end
 %MeanDist_neighbors_to_neighbors_t = sum(Dist_neighbors_to_neighbors_t, 3)/ (nb_nearest_neighbors);

 % get their relative source neighbors idx
 Idx_s = zeros(size(keypoints_t,1),nb_nearest_neighbors+1);
 for i=1:1:size(keypoints_t,1)
    Idx_s(i, :) = target_source_matchings_sorted(Idx_t(i,:),2);
 end

 % compute distance from each source neighbor to each source neighbor
 Dist_neighbors_to_neighbors_s = zeros(size(keypoints_t, 1), nb_nearest_neighbors+1, nb_nearest_neighbors+1 );
 for n = 1:1:size(keypoints_t,1)
     Dist_neighbors_to_neighbors_s(n, : ,:) = reshape(sqrt(sum((repmat(keypoints_s(Idx_s(n, :), :), nb_nearest_neighbors+1, 1)- repelem(keypoints_s(Idx_s(n, :), :), nb_nearest_neighbors + 1,  1)).^2, 2)), [nb_nearest_neighbors+1, nb_nearest_neighbors+1]);
 end
% MeanDist_neighbors_to_neighbors_s = sum(Dist_neighbors_to_neighbors_s, 3)/ (nb_nearest_neighbors);
 
% compare neighbor distances in source and target
matrix_ratio = Dist_neighbors_to_neighbors_t./Dist_neighbors_to_neighbors_s;
matrix_ratio(isnan(matrix_ratio)) = 1;
bool_inliers = matrix_ratio > sr1 & matrix_ratio < sr2;
matrix_indices = permute(repmat(Idx_s, 1 ,1, nb_nearest_neighbors+1), [1 3 2]);
inliers_candidates_indices = matrix_indices(bool_inliers); 
source_keypoints_indices = (1:1:size(keypoints_s,1))';
occurences = hist(inliers_candidates_indices, source_keypoints_indices);
inlier_indices = source_keypoints_indices(occurences > threshold);
target_source_matchings_checked = target_source_matchings_sorted(ismember(target_source_matchings_sorted(:, 2), inlier_indices), :);

end


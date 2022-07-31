function target_source_matchings_checked = distance_check_matching_pairs_bis(keypoints_s, keypoints_t, target_source_matchings , nb_nearest_neighbors, distance_error, threshold)


% sort matchings along target index
target_source_matchings_sorted = sortrows(target_source_matchings);

% get the nearest neighbor index of each target keypoint
 keypoints_with_match_t = keypoints_t(target_source_matchings_sorted(:, 1),:);
 keypoints_with_match_s = keypoints_s(target_source_matchings_sorted(:, 2),:);
 Idx_t = knnsearch(keypoints_with_match_t, keypoints_with_match_t,'K', nb_nearest_neighbors+1);
 
 % compute distance from each target neighbor to each target neighbor
 Dist_neighbors_to_neighbors_t = zeros(size(keypoints_with_match_t, 1), nb_nearest_neighbors+1, nb_nearest_neighbors+1 );
 for n = 1:1:size(keypoints_with_match_t,1)
     Dist_neighbors_to_neighbors_t(n, : ,:) = reshape(sqrt(sum((repmat(keypoints_with_match_t(Idx_t(n, :), :), nb_nearest_neighbors+1, 1)- repelem(keypoints_with_match_t(Idx_t(n, :), :), nb_nearest_neighbors + 1,  1)).^2, 2)), [nb_nearest_neighbors+1, nb_nearest_neighbors+1]);
 end
 % get mean neighbor distance of each target keypoint
 MeanDist_neighbors_to_neighbors_t = sum(sum(Dist_neighbors_to_neighbors_t, 3), 2)/(nb_nearest_neighbors*(nb_nearest_neighbors + 1));

%  % get their relative source neighbors idx
%  Idx_s = zeros(size(keypoints_with_match_t,1), nb_nearest_neighbors+1);
%  for i=1:1:size(keypoints_with_match_t,1)
%     %Idx_s(i, :) = target_source_matchings_sorted(ismember(target_source_matchings_sorted(:, 1), Idx_t(i,:)'),2)';
%     Idx_s(i, :) = target_source_matchings_sorted(Idx_t(i,:),2);
%  end
% % get distances of neighbor source matchings  from each source matching keypoint
%  Dist_neighbors_to_keypoint_s = zeros(size(keypoints_with_match_t, 1), nb_nearest_neighbors+1);
%  for n = 1:1:size(keypoints_with_match_t,1)
%      Dist_neighbors_to_keypoint_s(n, :) = sqrt(sum((keypoints_s(Idx_s(n, :), :) - keypoints_s(Idx_s(n, 1), :)).^2, 2))';
%  end

% get distances of neighbor source matchings  from each source matching keypoint
 Dist_neighbors_to_keypoint_s = zeros(size(keypoints_with_match_t, 1), nb_nearest_neighbors+1);
 for n = 1:1:size(keypoints_with_match_t,1)
    Dist_neighbors_to_keypoint_s(n, :) = sqrt(sum((keypoints_with_match_s(Idx_t(n, :)', :) - keypoints_with_match_s(Idx_t(n, 1), :)).^2, 2))';
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
% inliers_indices = Idx_s(count >= threshold, 1);
% target_source_matchings_checked = target_source_matchings_sorted(ismember(target_source_matchings_sorted(:, 2), inliers_indices), :); 

end




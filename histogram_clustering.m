function [hists_array_labelled, nb_clusters] = histogram_clustering(hists_array, percentage_of_similarity)
% this function computes a clustering of keypoints descriptors histograms.
% The first parameter is a m-by-k array that corresponds to the matrix of 
% associated descriptors of the keypoints (k is the lenght of the descriptor 
% histogram and m the number of keypoints). 
% The second parameter is the percentage of similarity that each keypoint 
% descriptor must share with others to belong to the same cluster. 
% The output is a labelled matrix of keypoints descriptors and the number
% of clusters detected (given the percentage of similarity)

nb_points = size(hists_array,1);
search_hists = hists_array;
max_label = 0;
keypoints_descriptors_label_and_minDist = zeros(nb_points,2);
indices = (1:1:nb_points)';
for i=1:1:nb_points
    query_hist = hists_array(i,:);
    search_hists(1,:) = []; 
    indices(1) = [];
    [similarity_percentages,dists_l2] = histogram_similarity(query_hist, search_hists);
    if keypoints_descriptors_label_and_minDist(i,1) == 0
        % update label value
        max_label = max_label+1;
        % update query descriptor label
        keypoints_descriptors_label_and_minDist(i,1) = max_label;
        keypoints_descriptors_label_and_minDist(i,2) = realmax;
        % set current label value
        current_label = max_label;
    else
        % set current label value
         used_label = keypoints_descriptors_label_and_minDist(i,1);
         current_label = used_label;
    end
    % update neighbor descriptors label
    if (~ isempty(similarity_percentages))
        neighbors_indices = indices(similarity_percentages >= percentage_of_similarity, 1);
        logical_neighbors_indices = zeros(nb_points,1);
        logical_neighbors_indices(neighbors_indices) = 1;
        logical_neighbors_and_0_value_indices = logical(logical_neighbors_indices) & (keypoints_descriptors_label_and_minDist(:,1) == 0);
        logical_neighbors_and_positive_value_indices = logical(logical_neighbors_indices) & (keypoints_descriptors_label_and_minDist(:,1) ~= 0);
        if any(logical_neighbors_and_0_value_indices)
            keypoints_descriptors_label_and_minDist(logical_neighbors_and_0_value_indices,1) = current_label;
            keypoints_descriptors_label_and_minDist(logical_neighbors_and_0_value_indices, 2) = dists_l2(logical_neighbors_and_0_value_indices(i+1:end));
        end
        if any(logical_neighbors_and_positive_value_indices)
            [m, idx] = min([keypoints_descriptors_label_and_minDist(logical_neighbors_and_positive_value_indices, 2), dists_l2(logical_neighbors_and_positive_value_indices(i+1:end))], [], 2);
            keypoints_descriptors_label_and_minDist(logical_neighbors_and_positive_value_indices, 1) = current_label .*(idx ==2) + keypoints_descriptors_label_and_minDist(logical_neighbors_and_positive_value_indices, 1) .*(idx ==1);
            keypoints_descriptors_label_and_minDist(logical_neighbors_and_positive_value_indices, 2) = m.*(idx== 1) + m.*(idx ==2);    
        end
    end
end


nb_clusters = length(unique(keypoints_descriptors_label_and_minDist(:, 1)));
hists_array_labelled = [keypoints_descriptors_label_and_minDist(:, 1), hists_array];

end


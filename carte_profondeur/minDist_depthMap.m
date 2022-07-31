function min_depthMap = minDist_depthMap(depthMap_query, depthMaps_ref)

% change image dynamique
depthMap_query = (1-depthMap_query)*255;
depthMaps_ref = (1-depthMaps_ref)*255;

% compute correlation
max_corr = zeros(size(depthMaps_ref, 3), 1);
indices = zeros(size(depthMaps_ref, 3), 1);
for k = 1:1:size(depthMaps_ref, 3)
    corr = xcorr2(depthMaps_ref(:,:,k), depthMap_query);
    [maxC, ic] = max(corr, [], 'all', 'linear');
    max_corr(k) = maxC;
    indices(k) = ic;
end

[maxCorr, index] = max(max_corr);
min_depthMap = depthMaps_ref(:, :, index);

% % get lag
% i= mod(indices, size(corr, 1));
% j = fix(indices/size(corr, 1)) +1;
% lags = [i , j];
% 
% % compute matrix indices
% ref_indices_i = [(lags(:, 1)>size(depthMaps_ref, 1)).*(lags(:, 1) - size(depthMaps_ref, 1)) + 1,  size(depthMaps_ref, 1) - (size(depthMaps_ref, 1)-lags(:, 1)).*(lags(:, 1)<size(depthMaps_ref, 1))];
% ref_indices_j = [(lags(:, 2)>size(depthMaps_ref, 2)).*(lags(:, 2) - size(depthMaps_ref, 2)) + 1,  size(depthMaps_ref, 2) - (size(depthMaps_ref, 2)-lags(:, 2)).*(lags(:, 2)<size(depthMaps_ref, 2))];
% query_indices_i = [1+(lags(:, 1)<size(depthMap_query, 1)).*(size(depthMap_query, 1) - lags(:, 1)), size(depthMap_query, 1) - (lags(:, 1) - size(depthMap_query, 1)).*(lags(:, 1)>size(depthMap_query, 1))];
% query_indices_j = [1+(lags(:, 2)<size(depthMap_query, 2)).*(size(depthMap_query, 2) - lags(:, 2)), size(depthMap_query, 2) - (lags(:, 2) - size(depthMap_query, 2)).*(lags(:, 2)>size(depthMap_query, 2))];
% 
% % compute min dist depth map
% depthMap_query_stacked = repmat(depthMap_query, 1, 1, size(depthMaps_ref, 3));
% [min_dist, ind] = min(sqrt(sum((depthMap_query_stacked(query_indices_i(:, 1):query_indices_i(:, 2), query_indices_j(:, 1):query_indices_j(:, 2)) -  depthMaps_ref(ref_indices_i(:, 1):ref_indices_i(:, 2), ref_indices_j(:, 1):ref_indices_j(:, 2))).^2, [1, 2]))); 
% min_depthMap = depthMaps_ref(:, :, ind);

end


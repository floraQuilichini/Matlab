function [closest_features, indices] = dist_features(query_features, ref_features)
% query_features : k-by-m feature matrix (where m is the number of query features and k the size of the feature)
% ref_features : k-by-n feature matrix (where n is the number of reference features and k the size of the feature)
% indices : 1-by-m vector (with values ranging from 1 to n)

m = size(query_features, 2);
n = size(ref_features, 2);
dists = reshape(sqrt(sum((repelem(query_features, 1, n) - repmat(ref_features, 1, m)).^(2), 1)), n, m);
[min_dists, indices] = min(dists, [], 1);
closest_features = ref_features(:, indices');

end


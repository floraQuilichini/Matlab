function [percentage_of_similarity, l2_dist] = histogram_similarity(hist1,hists_array)
% compute the similarity between an histogram (ie a query row vector of lenght k)
% and an array of histograms (a m-by-k matrix with a k-histogram on each row).
% The function returns the percentage of similarity between the histograms. 
% The similarity is computed using the euclidian distance

if size(hist1, 2) ~= size(hists_array, 2)
    error("hist1 and hist2 must have the same length");
end
if size(hist1,1) ~= 1
    error("hist1 must be a vector");
end

% normalize histograms
hist1_normed = hist1 /sum(hist1);
hists_array_normed = hists_array ./ sum(hists_array, 2);

% compute L2 histgoram distance
dist_bin_array = abs(repmat(hist1_normed, size(hists_array,1),1) - hists_array_normed);
l2_dist  = sqrt(sum(dist_bin_array.*dist_bin_array,2));

percentage_of_similarity = 100 - l2_dist*100;

end


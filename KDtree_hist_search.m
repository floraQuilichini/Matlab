function [IdxKD,dist] = KDtree_hist_search(hists_query, hists_training, varargin)
% function that use kdtree to perform histogram matching
% this function outputs the distance vector between matching pairs and the
% indexes in training closest to query

MdlKD = KDTreeSearcher(hists_training);
numvararg = length(varargin);
if numvararg == 1
    MdlKD.Distance = varargin{:};
else
    MdlKD.Distance = 'euclidean';
end

[IdxKD, dist] = knnsearch(MdlKD,hists_query);
best_matching_training_hist = hists_training(IdxKD);



end


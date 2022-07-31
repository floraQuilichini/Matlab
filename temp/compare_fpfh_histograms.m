function distance_array = compare_fpfh_histograms(source_file_fpfh,target_file_fpfh, T, k)
% function that returns an array of histogram distances between a k number
% of points of the target_file_fpfh and their corresponding matching points
% in source_file_fpfh. 
% T is the transformed matrix (rotation, translation, scaling) applied to
% the source point cloud to get the target point cloud

%read point-histogram of each file
h_array_source = readFPFHHistogram(source_file_fpfh);
h_array_target = readFPFHHistogram(target_file_fpfh);

% take k random points in h_array_target
nb_total_points = size(h_array_target, 2);
if ~isnumeric(k)
    if strcmp('all', k)
        k = nb_total_points;
    else
        error('k must be a number or the string "all"');
    end
end
idx = randsample(nb_total_points,k);
query_points = horzcat(h_array_target(idx).p);

% transform target points (in order to match source points)
query_point_transformed = inv(T)*[query_points; ones(1, k)];
query_point_transformed = query_point_transformed(1:3, :);
C = num2cell(query_point_transformed, 1);
[h_array_target(transpose(idx)).p] = C{:};

% find best matching with points in h_array_source
MdlKDT = KDTreeSearcher(transpose(horzcat(h_array_source(:).p)));
IdxKDT = knnsearch(MdlKDT,transpose(query_points));
best_matching_points = horzcat(h_array_source(IdxKDT).p);

% compare histograms of source and target matching points       
%    % homemade distance 
% distance_array = zeros(1, k);
% for i=1:1:k
%     distance_array(i) = compare_histograms(h_array_source(IdxKDT(i)).hx, h_array_source(IdxKDT(i)).hy, h_array_target(idx(i)).hx, h_array_target(idx(i)).hy);
% end
    % KL distance
Hy_source = vertcat(h_array_source(IdxKDT).hy);
Hy_target = vertcat(h_array_target(idx).hy);
distance_array = symmetricKLDiv(Hy_source, Hy_target, 'max');

end


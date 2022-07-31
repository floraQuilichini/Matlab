function distance_array = isFPFHRobustToScale(fpfh_model_file, fpfh_scaled_file, symmetry_type, T, k)
% function that returns an array of histogram distances between k number
% of points of the target_file_fpfh and their corresponding matching points
% in source_file_fpfh. 
% the aim of this function is to check that similar points are correctly matched
% during registration
% T is the transformed matrix (rotation, translation, scaling) applied to
% the source point cloud to get the target point cloud

%read point-histogram of each file
h_array_source = readFPFHHistogram(fpfh_model_file);
h_array_target = readFPFHHistogram(fpfh_scaled_file);

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
[h_array_target(idx').p] = C{:};

% find best matching with points in h_array_source
MdlES = ExhaustiveSearcher(transpose(horzcat(h_array_source(:).p)), 'Distance', 'seuclidean');
IdxES = knnsearch(MdlES,transpose(query_point_transformed));
best_matching_points = horzcat(h_array_source(IdxES).p);

% compare histograms of source and target matching points       
%    % homemade distance 
% distance_array = zeros(1, k);
% for i=1:1:k
%     distance_array(i) = compare_histograms(h_array_source(IdxKDT(i)).hx, h_array_source(IdxKDT(i)).hy, h_array_target(idx(i)).hx, h_array_target(idx(i)).hy);
% end
    % KL distance
Hy_source = vertcat(h_array_source(IdxES).hy);
Hy_target = vertcat(h_array_target(idx).hy);
distance_array_target_source = KLDiv(Hy_source, Hy_target);
distance_array_source_target = KLDiv(Hy_target, Hy_source);
if strcmp(symmetry_type, 'max')
    distance_array = max(distance_array_target_source, distance_array_source_target);
elseif strcmp(symmetry_type, 'mean')
    distance_array = mean(distance_array_target_source, distance_array_source_target);
else
    error('you must choose between "max" or "mean"');
end

end


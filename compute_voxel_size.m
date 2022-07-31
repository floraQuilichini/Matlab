function voxel_side_size = compute_voxel_size(pointCloud,sub_level, varargin)
% function that returns the voxel size for point cloud subsampling. 
% the user enters the point cloud he wants to subsample, the level of
% subsampling (2, 4, ...) and the scaling coefficients
numvararg = length(varargin);
if numvararg == 1
    scaling_coeff =  varargin{:};
    m = min(scaling_coeff);
else
    m = 1;
end

% compute mean distance between neighboors
[distance, test_points_indexes, neighbors_indexes] = getMeanDistanceBetweenNeighbours(pointCloud);
% compute voxel side size
%voxel_side_size = sub_level*(1.0/sqrt(3.0))*distance*m;
voxel_side_size = sub_level*(1.0)*distance*m;
display(voxel_side_size)

% display points where distance to neighboors is computed (red)
% display the neighboors (green)
figure
pcCoords = pointCloud.Location;
regular_points_indexes = setdiff((1:1:size(pcCoords, 1)), [test_points_indexes, reshape(neighbors_indexes, 1, [])]);
pcshow(pcCoords(regular_points_indexes, :), [1 1 1]);
hold on
pcshow(pcCoords(test_points_indexes, :), [1 0 0]);
hold on
pcshow(pcCoords(reshape(neighbors_indexes, 1, []), :), [0 1 0]);
hold off


% % display point cloud average subsampled
% pointCloud_average_down = pcdownsample(pointCloud,'gridAverage', double(voxel_side_size));
% display(pointCloud_average_down.Count)
% figure
% pcshow(pointCloud_average_down);

% % display point cloud random subsample
% pointCloud_random_down = pcdownsample(pointCloud,'random',0.5);
% display(pointCloud_random_down.Count)
% figure
% pcshow(pointCloud_random_down);

end


function [pc_centered, mean_point] = center_point_cloud(pc)
%function that center points of a point cloud at origin for each dimension
% it returns the mean point of the point cloud and the centered point cloud

pcCoords = pc.Location;
nb_points = size(pcCoords, 1);
mean_point = mean(pcCoords, 1);
mean_matrix = repmat(mean_point, nb_points, 1);
pcCoords_centered = pcCoords - mean_matrix;
pc_centered = pointCloud(pcCoords_centered);

end


function [distance_neighbors, test_points_indexes, neighbors_indexes] = getMeanDistanceBetweenNeighbours(pointCloud)
% function that compute the mean neighbooring distance between points of a
% point cloud

%% previous ratio
% pcCoord = pointCloud.Location;
% % determine the number of testing points to compute noise parameters
% [nb_points, ~] = size(pcCoord);
% if nb_points > 10000
%     nb_test_points = fix(nb_points/50);
% else
%     x = (0.1:0.1:1000);
%     y = -log(x) + 7.0957;
%     ratio = y(nb_points)/y(1);
%     nb_test_points = fix(nb_points*ratio);
%     display(nb_test_points);
% end

%% new ratio
pcCoord = pointCloud.Location;
% determine the number of testing points to compute noise parameters
[nb_points, ~] = size(pcCoord);
display(nb_points)
nb_test_points = fix(sqrt(7*(nb_points - 1)));
display(nb_test_points)

% pick randomly nb testing points in the pcCoord array
%test_points_indexes = floor(nb_points*rand(1, nb_test_points));
test_points_indexes = randi([1,nb_points],1,nb_test_points);

% find the 4 nearest neighbours of each test points
distance_neighbors = zeros(1, nb_test_points);
nb_neighbors = 4;
neighbors_indexes = zeros(nb_test_points, nb_neighbors);
for i=1:nb_test_points
    point_index = test_points_indexes(1, i);
    [indices,dists] = findNearestNeighbors(pointCloud,pcCoord(point_index, :),nb_neighbors);
    distance_neighbors(i) = mean(dists);
    neighbors_indexes(i, :) = indices;
end

% and compute the global neighbouring distance for this set of points
distance_neighbors = max(distance_neighbors);
display(distance_neighbors)

end


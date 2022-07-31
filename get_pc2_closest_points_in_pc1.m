function [ratio, subpc1] = get_pc2_closest_points_in_pc1(pc2,pc1, varargin)
%This function writes a pcd file that contains pc1 closest points from
%pc2. (we assume that pc2 < pc1)


% read varargin
numvararg = length(varargin);
% get output filename (if any)
if numvararg==0
    flag = 0;
elseif numvararg==1
    flag = 1;
    output_filename = varargin{1};
else
    error('there is only one optional parameter');     
end



pc1Coords = pc1.Location;
pc2Coords = pc2.Location;

[nb_pc2_points, ~] = size(pc2Coords);

% find pc2 most nearests neighbours in pc1
distance_neighbors = zeros(1, nb_pc2_points);
nb_neighbors = 1;
neighbors_indexes = zeros(nb_pc2_points, 1);
for i=1:nb_pc2_points
    [index_in_pc1,dist_from_pc1] = findNearestNeighbors(pc1,pc2Coords(i, :),nb_neighbors);
    distance_neighbors(i) = dist_from_pc1;
    if ~any(neighbors_indexes(:) == index_in_pc1)
        neighbors_indexes(i) = index_in_pc1;
    end
end
neighbors_indexes(neighbors_indexes==0) = [];

subpc1Coords = pc1Coords(neighbors_indexes, :);
if isempty(pc1.Normal)
    subpc1 = pointCloud(subpc1Coords);
else
    subpc1Normals = pc1.Normal;
    subpc1Normals = subpc1Normals(neighbors_indexes, :);
    subpc1 = pointCloud(subpc1Coords, 'Normal', subpc1Normals);
end

ratio= round(subpc1.Count/pc1.Count, 2);


% save 
if flag
    pcwrite(subpc1,output_filename,'Encoding','ascii');
end

end


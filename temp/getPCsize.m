function nb_points = getPCsize(pc_filename)
% function that returns the number of points in a point cloud
ptCloud = pcread(pc_filename);
nb_points = size(ptCloud, 1);

end


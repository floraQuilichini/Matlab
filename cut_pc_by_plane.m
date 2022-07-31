function [pc_up,pc_low, nb_points_pc_low] = cut_pc_by_plane(pc, plane, ratio)
%   this function enables the user to divide a point cloud (pc) into 2
%   smaller point clouds (pc_up, pc_low). The point cloud is cut along a
%   plane ('XY' or 'XZ' or 'YZ') specified by the user. The third input
%   parameter is to specify where to place the cutting plane. If the user
%   enters 0, then all the points will be in the upper point cloud. If he 
%   enters 1, then all the points will be in the lower point cloud. If he 
%   enters alpha (0<alpha<1), then all the points with last coordinate 
%   upper than (1-alpha)*min_coord + alpha*max_coord will belong to the 
%   upper point cloud and the others to the lower point cloud 
%   

range = zeros(1, 2);
index = 0;
if strcmp(plane, 'XY') || strcmp(plane, 'YX')
    range = pc.ZLimits; 
    index = 3;
elseif strcmp(plane, 'XZ')|| strcmp(plane, 'ZX')
    range = pc.YLimits; 
    index = 2;
elseif strcmp(plane, 'YZ') || strcmp(plane, 'ZY')
    range = pc.XLimits; 
    index = 1;
end

val = range(1, 1) + ratio*(range(1, 2) - range(1, 1));

pcCoord = pc.Location;
[l, c] = size(pcCoord); % get number of points in pc

xyzPoint_upper = zeros(l, c); % create two arrays to store the two parts of the pc
xyzPoint_lower = zeros(l, c);

% divide point cloud in two arrays
idx_up = 1;
idx_low = 1;
for i = 1:l
    if pcCoord(i, index) > val
        xyzPoint_upper(idx_up,:)= pcCoord(i, :);
        idx_up = idx_up + 1;
    else
        xyzPoint_lower(idx_low,:)= pcCoord(i, :);
        idx_low = idx_low + 1;
    end
end

% remove unused rows
if (idx_up > 1)
    xyzPoint_upper = xyzPoint_upper(1:idx_up - 1,:);
else
    xyzPoint_upper = [];
end
if (idx_low > 1)
    xyzPoint_lower = xyzPoint_lower(1:idx_low-1, :);
else
    xyzPoint_lower = [];    
end

pc_up = pointCloud(xyzPoint_upper); % cast arrays to point clouds
pc_low = pointCloud(xyzPoint_lower);
nb_points_pc_low  = idx_low - 1;

end


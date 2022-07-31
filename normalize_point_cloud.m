function [pc_normalized, norm] = normalize_point_cloud(pc)
%function that normalize a point cloud coordinates
% it outputs the normalized point cloud and the corresponding norm
% note : when the point cloud is centered, the norm corresponds to the
% scale. 

pcCoords = pc.Location;
squaredNormCoords = sum(pcCoords .* pcCoords, 2);
norm = sqrt(max(squaredNormCoords));
pcCoordsNormalized = pcCoords/norm;
pc_normalized = pointCloud(pcCoordsNormalized);

end


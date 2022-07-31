function [pc_normalized, norm, pmin, pmax] = normalizeByBoundingBox(pc)
% This function normalizes the point cloud with the help of it bounding box. 

% get bounding box parameters (min and max points)
[pmin, pmax] = computeBoundingBox(pc);
% center the point cloud inside the bounding box
pc_centered = moveBoundingBoxToUpperQuarterSpace(pc, pmin);
% normalize
norm = sqrt((pmax - pmin)*(pmax - pmin)');
pcCoordsN = 1.0/norm*pc_centered.Location;
pc_normalized = pointCloud(pcCoordsN + repmat(pmin, size(pcCoordsN, 1), 1));



end


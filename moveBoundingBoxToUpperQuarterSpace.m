function [pc_translated] = moveBoundingBoxToUpperQuarterSpace(pc, pmin)
% given a point cloud and it associated bounding box parameter, this
% function will move the minimum point of the of the bounding box to the
% origin and the point cloud in the upper quarter space
% pmin must be a row vector of size 3
% It outputs the translated point cloud

pcCoord = pc.Location();
pcCoord_translated = pcCoord - repmat(pmin, size(pcCoord, 1), 1);
pc_translated = pointCloud(pcCoord_translated);

end


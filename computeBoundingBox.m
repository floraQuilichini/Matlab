function [pmin, pmax] = computeBoundingBox(pc)
%compute the bounding box of the point cloud. 
% this function outputs the minimal point and maximal point of the bounding
% box

x_lims = pc.XLimits;
y_lims = pc.YLimits;
z_lims = pc.ZLimits;
pmin = [x_lims(1), y_lims(1), z_lims(1)];
pmax = [x_lims(2), y_lims(2), z_lims(2)];

end


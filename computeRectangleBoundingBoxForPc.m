function [boundingBox_size, min_point] = computeRectangleBoundingBoxForPc(pc)
% compute the rectangular bounding box of a point cloud. 
% the first returned parameter is a vector containing the bounding box
% parameters (width, height, length)
% the second returned parameter is the initial point of the bounding box


xrange = pc.XLimits;
yrange = pc.YLimits;
zrange = pc.ZLimits;

width = xrange(2) - xrange(1);
length = yrange(2) - yrange(1);
heigth = zrange(2) - zrange(1);

boundingBox_size = [width length heigth];
min_point = [xrange(1), yrange(1), zrange(1)];

end


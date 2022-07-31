function scale = compute_pc_scale(pc_centered)
% compute the scale of a point cloud (note : the point cloud must be
% centered first)

pcCoords = pc_centered.Location;
squaredNormCoords = sum(pcCoords .* pcCoords, 2);
scale = sqrt(max(squaredNormCoords));

end


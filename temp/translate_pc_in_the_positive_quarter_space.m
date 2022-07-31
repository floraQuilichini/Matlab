function [pc_in_upper_quarter_space, translation] = translate_pc_in_the_positive_quarter_space(normalized_centered_pc)
% this function translates a point cloud to the upper quarter space. 
% the "minimal" coordinate of the bounding box is put at origin
% the input point cloud must be previously centered and normalized

pcCoords = normalized_centered_pc.Location;
nb_points = size(pcCoords, 1);
min_bbox = min(pcCoords, [], 1);
translation_matrix = zeros(nb_points, 3);
for i=1:1:3
    if min_bbox(i) < 0
        translation_matrix(:, i) = abs(min_bbox(i))*ones(nb_points, 1);
    end
end

pcCoords_translated  = pcCoords + translation_matrix;
translation = translation_matrix(1, :);
pc_in_upper_quarter_space = pointCloud(pcCoords_translated);


end


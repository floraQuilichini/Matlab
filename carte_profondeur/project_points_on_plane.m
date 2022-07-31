function [theta] = project_points_on_plane(plane, points, frame_center)
%plane : string to choose between "XY", "ZX" or "YZ"
% points: n-by-3 matrix with point coordinates. 
% frame center : the center of the frame (that belongs to the plane) :
% 1-by-3 vector

switch plane
    case "XY"
        plane_coeff = [0 0 1 -frame_center(3)];
        points(:, 3) = abs(points(:, 3));
        n = [0 0 1];
    case "YX"
        plane_coeff = [0 0 1 -frame_center(3)];
        points(:, 3) = abs(points(:, 3));
        n = [0 0 1];
    case "ZX"
        plane_coeff = [0 1 0 -frame_center(2)];
        points(:, 2) = abs(points(:, 2));
        n = [0 1 0];
    case "XZ"
        plane_coeff = [0 1 0 -frame_center(2)];
        points(:, 2) = abs(points(:, 2));
        n = [0 1 0];
    case "YZ"
        plane_coeff = [1 0 0 -frame_center(1)];
        points(:, 1) = abs(points(:, 1));
        n = [1 0 0];
    case "ZY"
        plane_coeff = [1 0 0 -frame_center(1)];
        points(:, 1) = abs(points(:, 1));
        n = [1 0 0];
    otherwise
        error("planes must be either 'XY', 'YZ' or 'ZX'");
end
 
% compute point distance from plane
dist = dist_from_point_to_plane(points, plane_coeff);

% compute the distance between the center of the frame and the projection
% of th point on the plane
nb_points = size(points, 1);
CM = points - repmat(frame_center, nb_points, 1);
MH = -dist.*repmat(n, nb_points, 1);
CH = CM + MH;

% compute the angle between CH and the first vector (counterclockwise) that makes the plane)
theta = atan(CH(:, 2)./CH(:, 1));
end


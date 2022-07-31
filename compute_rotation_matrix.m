function [rot] = compute_rotation_matrix(theta,rot_axis)
% this function outputs the rotation matrix given the angle parameter
% (theta) and the axis of rotation (rot_axis -- choice between 'X', 'Y' and
% 'Z')

cos_t = cos(theta);
sin_t = sin(theta);
rot = zeros(3, 3);
if strcmp(rot_axis, 'X')
    rot(1, 1) = 1;
    rot(2, 2) = cos_t;
    rot(3, 2) = sin_t;
    rot(2, 3) = - sin_t;
    rot(3, 3) = cos_t;
elseif strcmp(rot_axis, 'Y')
    rot(1, 1) = cos_t;
    rot(2, 2) = 1;
    rot(3, 1) = - sin_t;
    rot(1, 3) = sin_t;
    rot(3, 3) = cos_t;
elseif strcmp(rot_axis, 'Z')
    rot(1, 1) = cos_t;
    rot(2, 2) = cos_t;
    rot(2, 1) = sin_t;
    rot(1, 2) = - sin_t;
    rot(3, 3) = 1;
else
    fprintf("error, you must choose between 'X', 'Y' and 'Z' for the rotation axis");
end
end


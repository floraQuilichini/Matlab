function T = compute_transform_matrix(theta, axis, trans, scale_coeff)
% function that computes a transform matrix (rotation, translation, scaling)
% from an angle and an axis of rotation, a vector of translation and the
% coefficients of the scaling matrix. 
% It outputs T (transformed matrix)

T = eye(4, 4);
rot = compute_rotation_matrix(theta, axis);
T(1:3, 1:3) = rot;
T(1:3, 4) = transpose(trans);
scale = compute_scale_matrix(scale_coeff);
T = T*scale;

end


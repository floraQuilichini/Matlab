function [point_cloud, remaining_indices, suppressed_indices] = project_depthmap(depth_map,image_size, principal_point, focal_length, skew, scaling_factor)
% we suppose that world frame is aligned with camera frame (eg there is no
% extrinsic matrix, only the intrinsic one.) r 
% image_size and principal_point are 1-by-2 vectors
% focal_length, skew and scaling_factor are scalars


% show depthmap
figure; imshow(depth_map, []);

% compute intrinsic matrix and its inverse
K = [focal_length skew principal_point(1); 0.0 focal_length principal_point(2); 0.0 0.0 1.0];
K_ext = eye(4, 4);
K_ext(1:3, 1:3) = K;
K_ext_inv = inv(K_ext);
% compute x,y,z coords from u,v coords and gray-level value
depth_map_flatten = double(reshape(depth_map.',1,[]));
remaining_indices = (1:1:image_size(1)*image_size(2));
suppressed_indices =  [];
%%indices(depth_map_flatten == 0) = [];
%depth_map_flatten(depth_map_flatten == 0) = [];
%suppressed_indices = remaining_indices(depth_map_flatten < 950);
%remaining_indices(depth_map_flatten < 950) = [];
%depth_map_flatten(depth_map_flatten < 950) = [];
v = ceil(remaining_indices/image_size(1));
u = rem(remaining_indices, image_size(1));
z = depth_map_flatten/scaling_factor;
homogeneous_camera_points = [double(u); double(v); ones(1, size(v, 2)); 1.0./z];
homogeneous_coords = repmat(z, 4, 1).*(K_ext_inv*homogeneous_camera_points);
coords = homogeneous_coords(1:3, :)';

% show point cloud
point_cloud = pointCloud(coords);
figure; pcshow(point_cloud,'MarkerSize', 20);

end


% we suppose that world frame is aligned with camera frame (eg there is no
% extrinsic matrix, only the intrinsic one.) r 

% parameters
focal_length = 525.0;
image_size = [640, 480];
%image_size = [128, 128];
principal_point = [319.5, 239.5];
skew = 0.0;
scaling_factor = 1000.0;

% load depthmap
%depth_map = imread("D:\autoencoder_data\depthmaps2\reconstructed\beta_000001_dilated\0000061-000002002155.png");
%mask = imread("D:\autoencoder_data\depthmaps\test\mask\05454-0002729-000091031314.png");
%depth_map(~mask) = 0;

%depth_map = depthmap_with_reduced_black_px;
%depth_map = depthmap_mod2;

depth_map = image_filtered;
figure; imshow(depth_map, []);

% compute intrinsic matrix and its inverse
K = [focal_length skew principal_point(1); 0.0 focal_length principal_point(2); 0.0 0.0 1.0];
K_ext = eye(4, 4);
K_ext(1:3, 1:3) = K;
K_ext_inv = inv(K_ext);
% compute x,y,z coords from u,v coords and gray-level value
depth_map_flatten = double(reshape(depth_map.',1,[]));
indices = (1:1:image_size(1)*image_size(2));
%indices(depth_map_flatten == 0) = [];
%depth_map_flatten(depth_map_flatten == 0) = [];
indices(depth_map_flatten < 950) = [];
depth_map_flatten(depth_map_flatten < 950) = [];
v = ceil(indices/image_size(1));
u = rem(indices, image_size(1));
z = depth_map_flatten/scaling_factor;
homogeneous_camera_points = [double(u); double(v); ones(1, size(v, 2)); 1.0./z];
homogeneous_coords = repmat(z, 4, 1).*(K_ext_inv*homogeneous_camera_points);
coords = homogeneous_coords(1:3, :)';

% show point cloud
point_cloud = pointCloud(coords);
figure; pcshow(point_cloud,'MarkerSize', 20);

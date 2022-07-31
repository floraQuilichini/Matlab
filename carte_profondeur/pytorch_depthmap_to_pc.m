
% parameters
focal_length = 525.0;
image_size = [480, 640];
principal_point = [319.5, 239.5];
skew = 0.0;
scaling_factor = 1000.0;

% load depthmap
depth_map = double(imread("D:\autoencoder_data\depthmaps2\reconstructed\beta_000001\img23.png"));

figure; imshow(depth_map, [])



K = [focal_length, skew, principal_point(1); 0.0, focal_length, principal_point(2); 0.0, 0.0, 1.0];
K_ext = eye(4, 4);
K_ext(1:3, 1:3) = K;
K_ext_inv = inv(K_ext);

z = reshape(depth_map',1,[])/scaling_factor;
bool_matrix = (z > 0.95);
v = repelem((1:1:image_size(1)), 1, image_size(2));
v = v(bool_matrix);
u =  repmat((1:1:image_size(2)), 1, image_size(1));
u = u(bool_matrix);  
z = z(bool_matrix);
homogeneous_camera_points = [u; v; ones(1, nnz(bool_matrix)); 1.0./z];
homogeneous_coords = z.*(K_ext_inv*homogeneous_camera_points);
coords = homogeneous_coords(1:3, :)';

% show point cloud
point_cloud_ = pointCloud(coords);
figure; pcshow(point_cloud_);
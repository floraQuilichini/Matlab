%% test scaling estimation GLS

% extract source params
file_source = 'C:\Registration\test_multiscale\mesh\liver_original_mesh.ply';
[Tri_source,Pts_source,data_source,comments] = plyread(file_source,'tri');
source_normals = [data_source.vertex.nx, data_source.vertex.ny, data_source.vertex.nz];
norm_source_normals = source_normals./sqrt(sum(source_normals.^2, 2));

% extract target params
file_target = 'C:\Registration\test_multiscale\mesh\liver_2000.ply';
[Tri_target,Pts_target,data_target,comments] = plyread(file_target,'tri');
target_normals = [data_target.vertex.nx, data_target.vertex.ny, data_target.vertex.nz];
norm_target_normals = target_normals./sqrt(sum(target_normals.^2, 2));


% scale, rotate and translate target 
Pts_target_t = Pts_target;
norm_target_normals_t = norm_target_normals;
% theta = 3.1416/2;
% rot_axis = 'X';
% nb_target_points = size(Pts_target, 1);
% trans_mat = compute_transform_matrix(theta, rot_axis, [0 0 10], [0.5 0.5 0.5]);
% Pts_target_t = [Pts_target, ones(nb_target_points, 1)]*trans_mat';
% Pts_target_t = Pts_target_t(:, 1:3);
% norm_target_normals_t = norm_target_normals*compute_rotation_matrix(theta,rot_axis)';


% select point in source and target where to compute the GLSs
% p_source = Pts_source(873, :);
% p_target = Pts_target_t(534, :);
% p_source = Pts_source(200, :);
% p_target = Pts_target_t(200, :);
p_source = Pts_source(29, :);
p_target = Pts_target_t(833, :);

% scale estimation
mean_neighboring_dist_target = getMeanDistanceBetweenNeighbours(pointCloud(Pts_target_t));
mean_neighboring_dist_source = getMeanDistanceBetweenNeighbours(pointCloud(Pts_source));

max_abs_scale = max(mean_neighboring_dist_target, mean_neighboring_dist_source);
min_abs_scale = min(mean_neighboring_dist_target, mean_neighboring_dist_source);

min_scale = 2*min_abs_scale;
max_scale = 15*max_abs_scale;

nb_samples = 500;
alpha = 1;
[lag, m_base] = shift_estimation(min_scale, max_scale, nb_samples, p_source, p_target, Pts_source, Pts_target_t, norm_source_normals, norm_target_normals_t, alpha);
se = get_relative_scale(lag, m_base);

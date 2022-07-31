    %% test scale estimation with source and target point cloud
    
    
% source  and target point cloud
% source = pcread('C:\Registration\test_multiscale\mesh\liver_original_mesh.ply');
% target = pcread('C:\Registration\test_multiscale\mesh\liver_2000.ply');
source  = pcread('C:\Registration\test_multiscale\mesh\bunny_down_089.ply');
target = pcread('C:\Registration\test_multiscale\mesh\bunny_down_089.ply');

% if source.Count> 1500
%     % downsample source
%     mean_neighboring_dist_source = getMeanDistanceBetweenNeighbours(source);
%     source = pcdownsample(source, 'gridAverage',sqrt((floor(source.Count/1500)))*mean_neighboring_dist_source);
%     target = pcdownsample(target, 'gridAverage',sqrt((floor(target.Count/1500)))*mean_neighboring_dist_source);
% end

%target = pcread('C:\Registration\test_multiscale\mesh\bunny_transformed.ply');

% transform
angle = 3*3.1416/2;
axis = 'X';
transform = compute_transform_matrix(angle, axis, [0 4 0], [0.5 0.5 0.5]);


% crop
%  [~, target] = cut_pc_by_plane(target, 'XY', 0.4);


% source and target points
source_pts = source.Location;

% target_pts = target.Location;
target_pts = [target.Location, ones(target.Count, 1)]*transform';
target_pts = target_pts(:, 1:3);
% source and target normals
source_normals = (source.Normal)./sqrt(sum((source.Normal).^2, 2));
target_normals = (target.Normal)./sqrt(sum((target.Normal).^2, 2));
target_normals = target_normals*compute_rotation_matrix(angle, axis)';

% scale range
mean_neighboring_dist_target = getMeanDistanceBetweenNeighbours(pointCloud(target_pts));
mean_neighboring_dist_source = getMeanDistanceBetweenNeighbours(source);

max_abs_scale = max(mean_neighboring_dist_target, mean_neighboring_dist_source);
min_abs_scale = min(mean_neighboring_dist_target, mean_neighboring_dist_source);

min_scale = 1*min_abs_scale;
max_scale = 200*max_abs_scale;

% nb samples
nb_samples = 500;

% log base
m_base = (max_scale/min_scale).^(1/(nb_samples-1));
min_log_scale = log(min_scale)/log(m_base);
max_log_scale = log(max_scale)/log(m_base);


% scale estimation

    % take random points in source and target to estimate the scale
nb_tests_points = 1;
nb_source_points = source.Count;
nb_target_points = size(target_pts, 1);
% indices_source = randperm(nb_source_points, nb_tests_points);
% indices_target = indices_source;
% indices_target = randperm(nb_target_points, nb_tests_points);
indices_source = (1:source.Count); %10246;
indices_target = 1611;
% indices_target = indices_source;
source_queries = source_pts(indices_source, :);
target_queries = target_pts(indices_target, :);

%     % or take uniformly down-sampled points
% source_pc_queries = pcdownsample(source,'gridAverage',2*mean_neighboring_dist_source*sqrt(nb_source_points/nb_target_points));
% target_pc_queries = pcdownsample(pointCloud(target_pts),'gridAverage',2*mean_neighboring_dist_target);
% nb_source_query_pts = source_pc_queries.Count;
% nb_target_query_pts = target_pc_queries.Count;
% if nb_source_query_pts > nb_target_query_pts
%     indices_source =  randperm(nb_source_query_pts,nb_target_query_pts);
%     source_queries = source_pc_queries.Location(indices_source, :);
%     target_queries = target_pc_queries.Location;
% elseif nb_source_query_pts < nb_target_query_pts
%     indices_target =  randperm(nb_target_query_pts, nb_source_query_pts);
%     target_queries = target_pc_queries.Location(indices_target, :);
%     source_queries = source_pc_queries.Location;
% else
%     source_queries = source_pc_queries.Location;
%     target_queries = target_pc_queries.Location;
% end

        % visualize points
figure; pcshow(target_pts); hold on; pcshow(target_queries, [1 0 0], 'MarkerSize', 18); hold on; pcshow(source_pts); hold on; pcshow(source_queries, [1 0 0], 'MarkerSize', 18);

    % compute GLS descriptors on the points subset
[descriptors_source_query,descriptors_target_query] = cell_compute_source_and_target_descriptors(min_scale, max_scale, nb_samples, source_queries, target_queries, source_pts, target_pts, source_normals, target_normals);    
    
    % estimate scale 
alpha = 1;
w = [1; 1; 1];
[lag, Dsigma] = cell_lag_estimation_v2(descriptors_source_query, descriptors_target_query, nb_samples, w, alpha, 0.1);
relative_scale = m_base.^(-lag);



    % compute descriptors with estimated scale
nb_samples = 30;
        % rescale target data 
if relative_scale < 1  % if scale_source > scale_taret
    target_pts = target_pts*(1/relative_scale)*eye(3);
        % compute descriptors on target 
    [descriptors_source,descriptors_target] = cell_compute_source_and_target_descriptors(2*mean_neighboring_dist_source, 10*mean_neighboring_dist_source, nb_samples, source_pts, target_pts, source_pts, target_pts, source_normals, target_normals);
else
    source_pts = source_pts*relative_scale*eye(3);
        % compute descriptors on target 
    [descriptors_source,descriptors_target] = cell_compute_source_and_target_descriptors(2*mean_neighboring_dist_target, 10*mean_neighboring_dist_target, nb_samples, source_pts, target_pts, source_pts, target_pts, source_normals, target_normals);
    
end
    
    % compute similarity to make pairs
[pair_indices, cross_check_pair_indices] = cell_compute_similarity(descriptors_source, descriptors_target, w, alpha, nb_samples, 1);


    % write point-descriptor file 
output_dir = 'C:\Registration\test_multiscale';
output_target_file_name = 'target_gls_descriptors';
output_source_file_name = 'source_gls_descriptors';
output_file_ext = '.bin';

target_initial_indices = (1:1:nb_target_points);
source_initial_indices = (1:1:nb_source_points);

write_point_descriptor_file(target_pts(cross_check_pair_indices(:, 2), :), descriptors_target(cross_check_pair_indices(:, 2), :, :), nb_samples*3, 'GLS', output_dir, output_target_file_name, output_file_ext, 'cross_check', cross_check_pair_indices);
write_point_descriptor_file(source_pts(cross_check_pair_indices(:, 1), :), descriptors_source(cross_check_pair_indices(:, 1), :, :), nb_samples*3, 'GLS', output_dir, output_source_file_name, output_file_ext, 'cross_check', cross_check_pair_indices);


output_file_ext = '.txt';

write_point_descriptor_file(target_pts(cross_check_pair_indices(:, 2), :), descriptors_target(cross_check_pair_indices(:, 2), :, :), nb_samples*3, 'GLS', output_dir, output_target_file_name, output_file_ext, 'cross_check', cross_check_pair_indices);
write_point_descriptor_file(source_pts(cross_check_pair_indices(:, 1), :), descriptors_source(cross_check_pair_indices(:, 1), :, :), nb_samples*3, 'GLS', output_dir, output_source_file_name, output_file_ext, 'cross_check', cross_check_pair_indices);


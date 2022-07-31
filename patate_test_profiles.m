%% read gls file from Patate, compute matching and plot profiles

%%
% params
pc_target = pcread('D:\Registration\test_multiscale\mesh\liver_2000.ply');
pc_source = pcread('D:\Registration\test_multiscale\mesh\liver_original_mesh.ply');

% then call patate functions to compute descriptors on source and target

%%

% read data
filename_target =  'D:\Registration\test_multiscale\output\liver_2000_profiles.txt';
filename_source =  'D:\Registration\test_multiscale\output\liver_original_mesh_profiles.txt';


[source_profiles, header_source] = extract_data(filename_source);
[target_profiles, header_target] = extract_data(filename_target);

% read header
nb_source_points = str2double(header_source{5, 1});
nb_target_points = str2double(header_target{5, 1});
nb_samples = str2double(header_source{4, 1});
min_scale = str2double(header_source{1, 1});
max_scale = str2double(header_source{2, 1});
m_base = str2double(header_source{3, 1});

% relative scale estimation
nb_test_points = nb_target_points;
is = (repelem(randperm(nb_source_points, nb_test_points), nb_samples)' - 1)* nb_samples + repmat((1:1:nb_samples)', nb_test_points, 1);
it = (repelem(randperm(nb_target_points, nb_test_points), nb_samples)' - 1)* nb_samples + repmat((1:1:nb_samples)', nb_test_points, 1);
test_target_profiles = permute(reshape(target_profiles(it, :), nb_samples, nb_test_points, 3), [2 3 1]);
test_source_profiles = permute(reshape(source_profiles(is, :), nb_samples, nb_test_points, 3), [2 3 1]);

% estimate scale 
alpha = 1;
w = [1; 1; 1];
lag = cell_lag_estimation_v2(test_source_profiles, test_target_profiles, nb_samples, w, alpha, 0.1);
relative_scale = m_base.^(-lag);


% write ply file 
pc_target_coords = pc_target.Location*(1/relative_scale);
pc_target = pointCloud(pc_target_coords,'Normal',pc_target.Normal);
% filename_target_rescaled = 'C:\Registration\test_multiscale\mesh\liver_2000_rescaled.ply';
% pcwrite(pc_target, filename_target_rescaled, 'Encoding', 'ascii');


%%

% call patate functions to compute profiles on rescaled data
% then load the new target file
nb_samples = 30;
min_scale = max_scale/5;
filename_target_rescaled =  'C:\Registration\test_multiscale\output\liver_2000_rescaled_profiles.txt';
filename_source_rescaled =  'C:\Registration\test_multiscale\output\liver_original_mesh_rescaled_profiles.txt';
[target_profiles, header_target] = extract_data(filename_target_rescaled);
[source_profiles, header_source] = extract_data(filename_source_rescaled);

target_profiles = permute(reshape(target_profiles, nb_samples, nb_target_points, 3), [2 3 1]);
source_profiles = permute(reshape(source_profiles, nb_samples, nb_source_points, 3), [2 3 1]);

[pair_indices, cross_check_pair_indices] = cell_compute_similarity(source_profiles, target_profiles, w, alpha, nb_samples, 1);

matching_source_profiles = source_profiles(cross_check_pair_indices(:, 1), :, :);
matching_target_profiles = target_profiles(cross_check_pair_indices(:, 2), :, :);

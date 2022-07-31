function parameters = compute_input_parameters(pc_source_filename, pc_target_filename, base)

source = pcread(pc_source_filename);
target = pcread(pc_target_filename);

%% get source parameters
min_source_scale = getMeanDistanceBetweenNeighbours(source);
[~, max_source_scale, ~] = compute_pca_bbox(source, 0);

N_source = round((log(max_source_scale) - log(min_source_scale))/log(base)) + 1;

% correct max_source_scale in order to have exact result
max_source_scale = min_source_scale*base.^(N_source-1);


%% get target parameters
min_target_scale = getMeanDistanceBetweenNeighbours(target);
[~, max_target_scale, ~] = compute_pca_bbox(target, 0);

N_target = round((log(max_target_scale) - log(min_target_scale))/log(base)) + 1;

% correct max_target_scale in order to have exact result
max_target_scale = min_target_scale*base.^(N_target-1);

%%

parameters = [min_source_scale, max_source_scale, N_source, min_target_scale, max_target_scale, N_target, base];

end


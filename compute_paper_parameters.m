function parameters = compute_paper_parameters(pc_source_filename, pc_target_filename)

% compute the algorithm parameters from the paper "Relative scale
% estimation and 3D registration of multi-modal geometry using GLS" 
% (see section Parameters p10)
% https://www.irit.fr/recherches/STORM/MelladoNicolas/3d-multimodal-point-clouds-and-meshes/

pc_source = pcread(pc_source_filename);
pc_target = pcread(pc_target_filename);

min_source_scale = getMeanDistanceBetweenNeighbours(pc_source);
min_target_scale = getMeanDistanceBetweenNeighbours(pc_target);
[~, max_source_scale, ~] = compute_pca_bbox(pc_source, 0);
[~, max_target_scale, ~] = compute_pca_bbox(pc_target, 0);
max_source_scale = max_source_scale / 4.0;
max_target_scale = max_target_scale / 4.0;
log_base = 1.02;
nb_source_samples = floor(log(max_source_scale/min_source_scale)/log(log_base))+1;
nb_target_samples = floor(log(max_target_scale/min_target_scale)/log(log_base))+1;
md_source = 0.01*max_source_scale;
md_target = 0.01*max_target_scale;
ep = 0.4; % in centimeters
en = cos(3.1416/9.0); % the angle between normals must be inferior to 20°
es = 0.2;

parameters = [log_base, min_source_scale, max_source_scale, nb_source_samples, min_target_scale, max_target_scale, nb_target_samples, md_source, md_target, es, ep, en];
end


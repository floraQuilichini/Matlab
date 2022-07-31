function [scale_source, scale_target] = process_input_data(source_filename,target_filename)
% this fuction is used to process the noisy, rotated, translated and scaled
% data point clouds (source and target). Before running FPFH and FGR
% algorithm, we need to get free from scale parameter


%% normalize points clouds  (old version with bounding box)

% [pc_source_processed, source_scale, bb_pmin_source, bb_pmax_source] = normalizeByBoundingBox(pc_source);
% [pc_target_processed, target_scale, bb_pmin_target, bb_pmax_target] = normalizeByBoundingBox(pc_target);
% 
% bb_source = [bb_pmin_source; bb_pmax_source];
% bb_target = [bb_pmin_target; bb_pmax_target];



%% read data
ptCloud_source = pcread(source_filename);
ptCloud_target = pcread(target_filename);

%% center and normalize points clouds (current version )
    
    % source
ptCloud_source_centered = center_point_cloud(ptCloud_source);
[ptCloud_source_centered_and_normalized, scale_source] = normalize_point_cloud(ptCloud_source_centered);
    % target
ptCloud_target_centered = center_point_cloud(ptCloud_target);
[ptCloud_target_centered_and_normalized, scale_target] = normalize_point_cloud(ptCloud_target_centered);  

%% save points clouds
pcwrite(ptCloud_source_centered_and_normalized,source_filename,'Encoding','ascii');
pcwrite(ptCloud_target_centered_and_normalized,target_filename,'Encoding','ascii');


end


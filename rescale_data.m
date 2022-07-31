function [max_scale, mean_source, mean_target] = rescale_data(source_filename,target_filename)
% this fuction is used to rescale source and taget point cloud; We compute
% the maximum scale of the two point clouds and divide both of their
% coordinates by this scale


%% read data
ptCloud_source = pcread(source_filename);
ptCloud_target = pcread(target_filename);


%% center point clouds
[ptCloud_source_centered, mean_source] = center_point_cloud(ptCloud_source);
[ptCloud_target_centered, mean_target] = center_point_cloud(ptCloud_target);

%% compute maximum scale
source_scale = compute_pc_scale(ptCloud_source_centered);
target_scale = compute_pc_scale(ptCloud_target_centered);
max_scale = max(source_scale, target_scale);


%% rescale both point clouds
pcSourceCenteredCoords = ptCloud_source_centered.Location;
pcTargetCenteredCoords = ptCloud_target_centered.Location;
ptCloud_source_rescaled = pointCloud(pcSourceCenteredCoords/max_scale);
ptCloud_target_rescaled = pointCloud(pcTargetCenteredCoords/max_scale);
 

%% save points clouds in ascii file
% [path, name, ext] = fileparts(source_filename);
% source_filename = fullfile(path, strcat(name, '_rescaled_', ext));
% [path, name, ext] = fileparts(target_filename);
% target_filename = fullfile(path, strcat(name, '_rescaled_', ext));

pcwrite(ptCloud_source_rescaled,source_filename,'Encoding','ascii');
pcwrite(ptCloud_target_rescaled,target_filename,'Encoding','ascii');


end



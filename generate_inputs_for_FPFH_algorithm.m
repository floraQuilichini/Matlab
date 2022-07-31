function [full_output_directory, source_names, target_names] = generate_inputs_for_FPFH_algorithm(output_directory, source_filename, target_filename, theta, rot_axis, trans, scale_coeff, cutting_plane, ratio, nb_pc_target, type_of_noise, noise_generation, varargin)
%function that generate the inputs of FPFH algorithm (ie : at least two pcd
%files corresponding to the source point cloud and the target point cloud).
%The user has to enter the output directory (where the source point cloud and 
% target point cloud will be generated), the full filename of the point cloud 
% source model and the point cloud target model,
%and then a set of parameters cooresponding to the operations to apply on the 
%point cloud to obtain the target point cloud. 
%These parameters are :  
% - the transform to apply. The user has to enter four parameters : the angle
% theta and axis of rotation for the rotation, the translation vector, and
% the scale coefficients vector
% - the cutting plane, ratio, and number of returned point clouds. 
% If the target point cloud is a cropped version of the source point cloud, 
% the user has specify the cutting direction (chose between 'XY', 'YZ' and 'ZX'),
% the ratio of points he wants and the number of returned point clouds (1
% or 2). By default, the algorithm select the down cropped part of the
% point cloud.
% - the noise to apply. The user has to specify the type of noise he wants
% to add ('gaussian' or 'white'). If he wants to set by himself the noise
% parameters, he has to set the twelveth parameter to 'man' and then enter the 
% mean vector and standard deviation vector for source and target point clouds. 
% Otherwise, if he wants this process to be done automatically, he has to set
% the twelveth parameter to 'auto' he has to enter the number of noise matrix 
% he wants to apply to both point clouds (source and target), and the noise
% levels for source and target. 
% returns the output directory 


%% reading noise inputs

numvararg = length(varargin);
if numvararg > 4
    error('there are at most 4 optional parameters (mean and standard deviation vectors for both source and target point clouds or number of noise matrices and noise level for both source and target point cloud)');
end

if ~strcmp(type_of_noise, 'gaussian') && ~strcmp(type_of_noise, 'white')
    error('you must choose noise type between "gaussian" and "white"');
end

if ~strcmp(noise_generation, 'man') && ~strcmp(noise_generation, 'auto')
    error('you must choose noise generation between "man" and "auto"');
end


if numvararg == 4 && strcmp(noise_generation, 'man')
    [mean_vector_source, sd_vector_source, mean_vector_target, sd_vector_target] = varargin{:};
    if size(mean_vector_source) ~= size(sd_vector_source) || size(mean_vector_target) ~= size(sd_vector_target)
        error('mean and deviation vectors for a given point cloud must have the same length');
    else
        if mean_vector_source == zeros(1, size(mean_vector_source)) && sd_vector_source == zeros(1, size(sd_vector_source))
            nb_noise_matrix_source = 0;
        elseif mean_vector_target == zeros(1, size(mean_vector_target)) && sd_vector_target == zeros(1, size(sd_vector_target))
            nb_noise_matrix_target = 0;
        else
            nb_noise_matrix_source = size(mean_vector_source);
            nb_noise_matrix_target = size(mean_vector_target);
        end
    end
elseif numvararg == 4 && strcmp(noise_generation, 'auto')
    [nb_noise_matrix_source, noise_level_source, nb_noise_matrix_target, noise_level_target] = varargin{:};
else
    error('number of noise parameters insufficiant ');
end


%% loading point cloud 

[~, name_source, ~] = fileparts(source_filename);
%ptCloud_source = pcread(source_filename);
[source_faces, ptCoords_source] = plyread(source_filename, 'tri'); % must be ascii encoded
[~, name_target, ~] = fileparts(target_filename);
ptCloud_target = pcread(target_filename);
%pcshow(ptCloud_source);

%% cast point clouds coordinates to a type readable by PCL load function

% ptCloud_source = pointCloud(single(ptCloud_source.Location));
ptCloud_source = pointCloud(single(ptCoords_source));
ptCloud_target = pointCloud(single(ptCloud_target.Location));
 

%% source point cloud generation
    % add noise to the model
if nb_noise_matrix_source ~= 0
    if strcmp(noise_generation, 'auto')
        [ptCloudSourceCoord_noise, mean_vector_source, sd_vector_source] = add_noise_to_pc(ptCloud_source, type_of_noise, nb_noise_matrix_source, noise_level_source);
    else
        ptCloudSourceCoord_noise = add_noise_to_pc(ptCloud_source, type_of_noise, nb_noise_matrix_source, mean_vector_source, sd_vector_source);
    end
else
    ptCloudSourceCoord_noise = ptCloud_source.Location;
    mean_vector_source = 0;
    sd_vector_source = 0;
end
%     % save source point cloud
% [~, source_names] = save_pc(name_source, '_source_',  ptCloudSourceCoord_noise, mean_vector_source, sd_vector_source, theta, rot_axis, trans, output_directory);

    % save source mesh
for i=1:1:size(ptCloudSourceCoord_noise, 3)
    Data.vertex.x = ptCloudSourceCoord_noise(:, 1, i);
    Data.vertex.y = ptCloudSourceCoord_noise(:, 2, i);
    Data.vertex.z = ptCloudSourceCoord_noise(:, 3, i);
    Data.face.vertex_indices = num2cell(source_faces - ones(size(source_faces)), 2)';
    [source_names, dir_path] = get_full_path_name(name_source, '_source_', mean_vector_source, sd_vector_source, theta, rot_axis, trans, output_directory);
    % write ply file
    plywrite(Data, fullfile(dir_path, strcat(source_names(i), '.ply')), 'ascii');
    % write pcd file
    save_pc(name_source, '_source_',  ptCloudSourceCoord_noise(:,:,i), mean_vector_source, sd_vector_source, theta, rot_axis, trans, output_directory);
%     % write ascii files
%     [~,source_name,ext] = fileparts(source_names(i));
%     fid = fopen(fullfile(dir_path, strcat(source_name, '_point_cloud_', '.txt')),'wt');
%     for ii = 1:size(ptCloudSourceCoord_noise(:, :, i),1)
%         fprintf(fid,'%5.6f ',ptCloudSourceCoord_noise(ii,:, i));
%         fprintf(fid,'\n');
%     end
%     fclose(fid);
%     fid = fopen(fullfile(dir_path, strcat(source_name, '_faces_', '.txt')),'wt');
%     for ii = 1:size(source_faces,1)
%         fprintf(fid,'%d ', 3, source_faces(ii,:) - ones(1, 3));
%         fprintf(fid,'\n');
%     end
%     fclose(fid);
end

%% target point cloud generation

    % compute T matrix from rotation and translation and scaling
T = compute_transform_matrix(theta, rot_axis, trans, scale_coeff);       
    % apply operations to point cloud
if nb_pc_target == 2
    % cut by plane
    [pc_up, pc_down, nb_points_pc_down] = cut_pc_by_plane(ptCloud_target, cutting_plane, ratio);
    % apply transform
    pc_down_coord_transform = applyTtoPc(pc_down.Location,T);
    pc_up_coord_transform = applyTtoPc(pc_up.Location,T);
    % add noise to the cut model
    if nb_noise_matrix_target == 0
        pc_down_coord_noise = pc_down_coord_transform;
        pc_up_coord_noise = pc_up_coord_transform;
    elseif strcmp(noise_generation, 'man')
        pc_down_coord_noise = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix_target, mean_vector_target, sd_vector_target);
        pc_up_coord_noise = add_noise_to_pc(pointCloud(pc_up_coord_transform), type_of_noise, nb_noise_matrix_target, mean_vector_target, sd_vector_target);
    else
        [pc_down_coord_noise, mean_vector_target, sd_vector_target] = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix_target, noise_level_target);
        pc_up_coord_noise = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix_target, noise_level_target);
    end
    % save target point clouds 
    [full_output_directory, target_down_names] = save_pc(name_target, '_target_down_', pc_down_coord_noise, mean_vector_target, sd_vector_target, theta, rot_axis, trans, output_directory, ratio, cutting_plane);
    [~, target_up_names] = save_pc(name_target, '_target_up_', pc_up_coord_noise, mean_vector_target, sd_vector_target, theta, rot_axis, trans, output_directory, ratio, cutting_plane);
    target_names = [target_down_names, target_up_names];
else
    % cut by plane
    if ratio ~= 0 && ratio ~= 1     
        [~, pc_down, nb_points_pc_down] = cut_pc_by_plane(ptCloud_target, cutting_plane, ratio);
    else
        pc_down = ptCloud_target;
    end
     % apply transform
     pc_down_coord_transform = applyTtoPc(pc_down.Location,T);
     % add noise to the cut model
     if nb_noise_matrix_target == 0
        pc_down_coord_noise = pc_down_coord_transform;
        mean_vector_target = 0;
        sd_vector_target = 0;
    elseif strcmp(noise_generation, 'man')
        pc_down_coord_noise = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix_target, mean_vector_target, sd_vector_target);
    else
        [pc_down_coord_noise, mean_vector_target, sd_vector_target] = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix_target, noise_level_target);
     end
    % save target point cloud
    [full_output_directory, target_names] = save_pc(name_target, '_target_', pc_down_coord_noise, mean_vector_target, sd_vector_target, theta, rot_axis, trans, output_directory, ratio, cutting_plane);
end

%% save model transform matrix
fid = fopen(fullfile(full_output_directory,'transform_matrix_model.txt'), 'wt');
for j = 1:1:size(T, 1)
    fprintf(fid, '%4.12f\t', T(j, :));
    fprintf(fid, '\n');
end

fclose(fid);

end


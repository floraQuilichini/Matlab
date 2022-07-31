%% user parameters
%file
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/modele/ObjetSynthetique_clean_full_res.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp2/ObjetSynthetique_simp_2.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp4/ObjetSynthetique_simp_4.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp8/ObjetSynthetique_simp_8.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp16/ObjetSynthetique_simp_16.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp32/ObjetSynthetique_simp_32.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp64/ObjetSynthetique_simp_64.ply';

%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp2/halfedge_collapse/ObjetSynthetique_simp2.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp4/halfedge_collapse/ObjetSynthetique_simp4.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp8/halfedge_collapse/ObjetSynthetique_simp8.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp16/halfedge_collapse/ObjetSynthetique_simp16.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp32/halfedge_collapse/ObjetSynthetique_simp32.ply';
%   pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp64/halfedge_collapse/ObjetSynthetique_simp64.ply';

 pc_filename = 'C:\Registration_meshes\synthetic_model\mesh_bruite\simp32\halfedge_collapse\ObjetSynthetique_simp32.ply';
 

% noise
type_of_noise = 'gaussian';
    % noise parameters
noise_level  = 1.0;
mean_vector = [];
sd_vector = [];
nb_noise_matrix = 3;
% cutting plane
cutting_plane = 'XZ';
ratio = 0.4;

% transform 
theta = 3.14/2; % rotation angle
rot_axis = 'X'; % rotation axis
    % compute rotation matrix
    rot = compute_rotation_matrix(theta, rot_axis); % rotation matrix
trans = [0, 10, 6]; % translation vector

%% compute T matrix from rotation and translation
T = eye(4, 4);
T(1:3, 1:3) = rot;
T(1:3, 4) = transpose(trans);

%% chargement du point cloud 

[filepath, name, ext] = fileparts(pc_filename);
ptCloud = pcread(strcat(filepath, '/', name, ext));
pcshow(ptCloud);

%% save original point cloud to pcd foramt readable by PCL function

ptCloudCoord_cast = single(ptCloud.Location);
ptCloud = pointCloud(ptCloudCoord_cast);

%% call function to rotate the model
%     % save original point cloud to pcd foramt readable by PCL function
% save_pc(name, '_', ptCloudCoord_cast, zeros(1, nb_noise_matrix), zeros(1, nb_noise_matrix), '', theta, rot_axis, trans);
% 
% 
%     % compute transformed coordinates
% ptCloudCoordT = applyTtoPc(ptCloudCoord_cast, T);
% 
%     % save model
% save_pc(name, '_T_', ptCloudCoordT, zeros(1, nb_noise_matrix), zeros(1, nb_noise_matrix), '', theta, rot_axis, trans);


%% call function to add noise to model 

%[pc_coord_noise, mean_vector, sd_vector] = add_noise_to_model_pc(ptCloud, type_of_noise, nb_noise_matrix, 0.5);

%% save pc
%save_pc(name, '', pc_coord_noise, mean_vector, sd_vector, '', theta, rot_axis, trans);

%% call function to cut, add noise to model and transform it (rotation + translation)
% function to cut the model
[~, pc_down] = cut_pc_by_plane(ptCloud, cutting_plane, ratio); 
% function to rotate both parts of the model 
pc_down_coord =  pc_down.Location;
[pc_down_coord_transform] = applyTtoPc(pc_down_coord,T);
% function to add noise to the cut model
if size(mean_vector) ~= 0
    pc_down_coord_noise = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix, mean_vector, sd_vector);
else
    [pc_down_coord_noise, mean_vector, sd_vector] = add_noise_to_pc(pointCloud(pc_down_coord_transform), type_of_noise, nb_noise_matrix, noise_level);
end

% function that regroups the previously mentionned steps
%[pc_up_coord_noise,pc_down_coord_noise, mean_vector, sd_vector] = get_2pc_from_model_pc(rot, trans, ptCloud, cutting_plane, ratio, type_of_noise, nb_noise_matrix, 1);

%% save pc

%save_pc(name, '_up_', pc_up_coord_noise, mean_vector, sd_vector, cutting_plane, theta, rot_axis, trans);
%save_pc(name, '_down_', pc_down_coord_noise, mean_vector, sd_vector, cutting_plane, theta, rot_axis, trans);
% save_pc(name, '_down_', pc_down_coord_transform, zeros(1, nb_noise_matrix), zeros(1, nb_noise_matrix), cutting_plane, theta, rot_axis, trans);
save_pc(name, '_down_', pc_down_coord_noise, mean_vector, sd_vector, cutting_plane, theta, rot_axis, trans);

%% compute subsampling step
distance = getMeanDistanceBetweenNeighbours(ptCloud);
% pour un subsampling de 2, on prend comme pas : (2/sqrt(3))*distance
step_subsampling = (2.0/sqrt(3.0))*distance;

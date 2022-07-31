%% test inverse transform


    % user parameters
    
target_dir = 'C:\Registration_meshes\synthetic_model\mesh_bruite\modele';
%output_dir = 'C:\Registration_meshes\synthetic_model\mesh_bruite\simp2\full_edge_collapse\theta0_t0_0_0Z';
output_dir = 'C:\Registration_meshes\synthetic_model\mesh_bruite\simp2\full_edge_collapse\theta0_t0_0_0Z';

    % pc registration
pcRegistration(output_dir, target_dir);
 
%%
% pc_source_file = 'C:\Users\fquilich\Documents\MATLAB\theta1.57_t0_10_6X\source.pcd';
% pc_target_file = 'C:\Users\fquilich\Documents\MATLAB\theta1.57_t0_10_6X\target.pcd';
pc_source_file = 'C:\Users\fquilich\Documents\MATLAB\test_just_rotation\ObjetSynthetique_simp32_m0_s0.pcd';
pc_target_file = 'C:\Users\fquilich\Documents\MATLAB\test_just_rotation\ObjetSynthetique_simp32_down_m0_s0XZ.pcd';
pc_source = pcread(pc_source_file);
pc_target = pcread(pc_target_file);
pc_sourceCoord = pc_source.Location;
pc_targetCoord = pc_target.Location;


dataT = importdata('C:\Users\fquilich\Documents\MATLAB\test_just_rotation\output2.txt'," ", 1);
% extract Transform
T = dataT.data(:,:);
 
 l = size(pc_targetCoord, 1);
 target_coord_h = ones(l, 4);
 target_coord_h(:,1:3) = pc_targetCoord;
 
target_coord_hT  = target_coord_h * transpose(T);
pc_target_transform = pointCloud(target_coord_hT(:, 1:3));

display_superimposed_pc(pc_target_transform, [255 0 0], pc_source, [0 255 0]);

%% true T
theta = 3.14/2; % rotation angle
rot_axis = 'X'; % rotation axis
    % compute rotation matrix
    rot = compute_rotation_matrix(theta, rot_axis); % rotation matrix
trans = [0, 10, 6]; % translation vector

% compute T_true matrix from rotation and translation
T_true = eye(4, 4);
T_true(1:3, 1:3) = rot;
T_true(1:3, 4) = transpose(trans);

% compute true transfrm
target_coord_hT_true  = target_coord_h * transpose(inv(T_true));
pc_target_true_transform = pointCloud(target_coord_hT_true(:, 1:3));

display_superimposed_pc(pc_target_transform, [255 0 0], pc_target_true_transform, [0 255 0]);


%%

pc_source_file = 'C:\Users\fquilich\Documents\MATLAB\theta1.57_t0_10_6X\Depth_0000.ply';
pc_target_file = 'C:\Users\fquilich\Documents\MATLAB\theta1.57_t0_10_6X\Depth_0001.ply';
pc_source = pcread(pc_source_file);
pc_target = pcread(pc_target_file);
pc_sourceCoord = single(pc_source.Location);
pc_targetCoord = single(pc_target.Location);

pcwrite(pointCloud(pc_sourceCoord),'source.pcd','Encoding','ascii');
pcwrite(pointCloud(pc_targetCoord),'target.pcd','Encoding','ascii');

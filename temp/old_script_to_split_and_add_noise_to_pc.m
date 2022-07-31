%% user parameters
%file
pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/modele/ObjetSynthetique_clean_full_res.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp2/ObjetSynthetique_simp_2.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp4/ObjetSynthetique_simp_4.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp8/ObjetSynthetique_simp_8.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp16/ObjetSynthetique_simp_16.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp32/ObjetSynthetique_simp_32.ply';
% pc_filename = 'C:/Registration_meshes/synthetic_model/mesh_bruite/simp64/ObjetSynthetique_simp_64.ply';


% noise
type_of_noise = 'gaussian';
    % noise parameters
mean_vector = [];
sd_vector = [];
nb_noise_matrix = 3;
% cutting plane
cutting_plane = 'XZ';
ratio = 0.3;



%% chargement du point cloud 

[filepath, name, ext] = fileparts(pc_filename);
ptCloud = pcread(strcat(filepath, '/', name, ext));
pcshow(ptCloud);


%% cut point cloud along a plane

[pc_up, pc_down] = cut_pc_by_plane(ptCloud, cutting_plane, ratio); 

pcshow(pc_up);
pcshow(pc_down);


%% add gaussian noise to point cloud

if size(mean_vector) ~= 0
    pc_up_coord_noise = add_noise_to_pc(pc_up, type_of_noise, nb_noise_matrix, mean_vector, sd_vector);
    pc_down_coord_noise = add_noise_to_pc(pc_down, type_of_noise, 3, mean_vector, sd_vector);
else
    [pc_up_coord_noise, mean_vector, sd_vector] = add_noise_to_pc(pc_up, type_of_noise, nb_noise_matrix);
    pc_down_coord_noise = add_noise_to_pc(pc_down, type_of_noise, 3);
end
    

%% retrieve point clouds and write them
for i=1:size(pc_up_coord_noise, 3)
    pc_up = pointCloud(pc_up_coord_noise(:,:,i));
    pcwrite(pc_up,strcat(name,'_up_m', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)), cutting_plane,'.ply'),'Encoding','binary');
    %pcshow(pc_up);
    %pause;
end

for i=1:size(pc_down_coord_noise, 3)
    pc_down = pointCloud(pc_down_coord_noise(:,:,i));
    pcwrite(pc_down,strcat(name,'_down_m', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)), cutting_plane,'.ply'),'Encoding','binary');
    %pcshow(pc_down);
    %pause;
end




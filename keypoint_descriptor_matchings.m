
write_pairs_flag = 1;
source_filename = "C:\Registration\RoPS_tests\heart_clean_full_res.ply";
target_filename = "C:\Registration\RoPS_tests\full_heart_rescaled_bis.ply";
[source_faces, source_pts, source_data,~] = plyread(source_filename,'tri');
[target_faces, target_pts, target_data,~] = plyread(target_filename,'tri');

 %============================read histogram descriptors============================%
 source_descriptors_file = "C:\Registration\RoPS_tests\heart_clean_full_res_iss_fpfh.txt";
 target_descriptor_file = "C:\Registration\RoPS_tests\full_heart_rescaled_bis_iss_fpfh.txt";
[mean_dist, pairs_target_source, count, nb_hist_source, nb_hist_target, nb_bins, hists_source, hists_target] = getFPFHHistogramsDistance(source_descriptors_file, target_descriptor_file, 0, 'L2_KDtree');

% %============================get the triangular mesh============================%
mesh.vertices = double(source_pts);
mesh.faces = source_faces;
[mean_edge_length, std_edge_length] = compute_edges_statistics(mesh.vertices, mesh.faces);
mesh.resolution = mean_edge_length;
mesh.stdeviation = std_edge_length;
mesh.vertexNormals = double([source_data.vertex.nx, source_data.vertex.ny, source_data.vertex.nz]);
% mesh.triangleNormals = compute_face_normal(mesh.vertices, mesh.vertexNormals, mesh.faces);
% mesh.vertexNtriangles = get_vertex_adjacent_faces(mesh.faces, size(source_pts, 1));
% mesh.triangleNtriangles = get_face_adjacent_faces(mesh.faces);

% %============================preprocessing============================%
% out = preprocessingFunc(mesh);
% mesh.faceCenter = out.centroid;
% mesh.faceArea = out.area;
% mesh.res = out.res ;
%============================get keypoints============================%
keypoints_pc = pcread('C:\Registration\RoPS_tests\heart_clean_full_res_iss_keypoints.ply');
source_keypoints = keypoints_pc.Location;
mesh.keypnt = source_keypoints;
mesh.keypntIdx = knnsearch(mesh.vertices,source_keypoints);
source_mesh = mesh;
%============================show the source mesh and its keypoints============================%
meshX = mesh;
angle = 0;%-90;
R = [1,0,0; 0,cos(angle*pi/180),sin(angle*pi/180); 0, -sin(angle*pi/180), cos(angle*pi/180)]';
meshX.vertices = mesh.vertices*R;
figure; trisurf(meshX.faces,meshX.vertices(:,1),meshX.vertices(:,2),meshX.vertices(:,3)); axis equal;
axis image; shading interp;lighting phong; view([0,0]);  hold on; colormap([1,1,1]*0.9);camlight right;hold on;axis off;
plot3(meshX.vertices(mesh.keypntIdx,1),meshX.vertices(mesh.keypntIdx,2),meshX.vertices(mesh.keypntIdx,3),'r.');

% %============================get the triangular mesh============================%
mesh.vertices = double(target_pts);
mesh.faces = target_faces;
[mean_edge_length, std_edge_length] = compute_edges_statistics(mesh.vertices, mesh.faces);
mesh.resolution = mean_edge_length;
mesh.stdeviation = std_edge_length;
mesh.vertexNormals = double([target_data.vertex.nx, target_data.vertex.ny, target_data.vertex.nz]);
% mesh.triangleNormals = compute_face_normal(mesh.vertices, mesh.vertexNormals, mesh.faces);
% mesh.vertexNtriangles = get_vertex_adjacent_faces(mesh.faces, size(target_pts, 1));
% mesh.triangleNtriangles = get_face_adjacent_faces(mesh.faces);
% %============================preprocessing============================%
% out = preprocessingFunc(mesh);
% mesh.faceCenter = out.centroid;
% mesh.faceArea = out.area;
% mesh.res = out.res ;
%============================get keypoints============================%
keypoints_pc = pcread('C:\Registration\RoPS_tests\full_heart_rescaled_bis_iss_keypoints.ply');
target_keypoints = keypoints_pc.Location;
mesh.keypnt= target_keypoints;
mesh.keypntIdx = knnsearch(mesh.vertices,target_keypoints);
target_mesh = mesh;
%============================show the target mesh and its keypoints============================%
meshX = mesh;
angle = 0;%-90;
R = [1,0,0; 0,cos(angle*pi/180),sin(angle*pi/180); 0, -sin(angle*pi/180), cos(angle*pi/180)]';
meshX.vertices = mesh.vertices*R;
figure; trisurf(meshX.faces,meshX.vertices(:,1),meshX.vertices(:,2),meshX.vertices(:,3)); axis equal;
axis image; shading interp;lighting phong; view([0,0]);  hold on; colormap([1,1,1]*0.9);camlight right;hold on;axis off;
plot3(meshX.vertices(mesh.keypntIdx,1),meshX.vertices(mesh.keypntIdx,2),meshX.vertices(mesh.keypntIdx,3),'r.');
% %============================get all the good pairs indices (debug)============================%
% % source_indices = (1:1:size(source_pts,1))';
% % source_keypoints_indices = source_indices(ismembertol(source_pts, source_keypoints, 10^(-4),'ByRows',true));
% % source_correct_keypoints_indices = source_keypoints_indices(ismembertol(source_keypoints, target_keypoints, 10^(-4), 'ByRows', true));
% % target_indices = (1:1:size(target_pts,1))';
% % target_keypoints_indices  = target_indices(ismembertol(target_pts, target_keypoints, 10^(-4), 'ByRows', true));
% % target_correct_keypoints_indices = target_keypoints_indices(ismembertol(target_keypoints, source_keypoints, 10^(-4), 'ByRows',true));
% % target_source_correct_matchings = [target_correct_keypoints_indices, source_correct_keypoints_indices];
% source_keypoints_indices = (1:1:size(source_keypoints,1))';
% source_correct_keypoints_indices = source_keypoints_indices(ismembertol(source_keypoints, target_keypoints, 10^(-4), 'ByRows', true));
% target_keypoints_indices = (1:1:size(target_keypoints,1))';
% target_correct_keypoints_indices = target_keypoints_indices(ismembertol(target_keypoints, source_keypoints, 10^(-4), 'ByRows',true));
% target_source_correct_matchings = [target_correct_keypoints_indices, source_correct_keypoints_indices];
%============================remove outliers============================%
 %target_source_matchings_checked = distance_check_matching_pairs_bis(source_keypoints, target_keypoints, pairs_target_source' , 10, 1.8, 5);
 %target_source_matchings_checked = geodesic_distance_check_matching_pairs_bis(source_faces, source_pts, target_faces, target_pts, source_keypoints, target_keypoints, pairs_target_source', 5, 1.8, 3);
%target_source_matchings_checked = distance_check_matching_pairs_bis(source_keypoints, target_keypoints, target_source_correct_matchings , 12, 0.3, 4);

%============================show matchings============================%
%  showCorresFunc_bis(source_mesh, target_mesh, target_source_matchings_checked(:, 2), target_source_matchings_checked(:, 1), [0,200,0]);
  showCorresFunc_bis(source_mesh, target_mesh, transpose(pairs_target_source(2, :)), transpose(pairs_target_source(1, :)), [0,200,0]);

 %============================write matching pairs============================%
if write_pairs_flag
    dim_descriptor = nb_bins;
    descriptor_type = "FPFH";
    output_dir = "C:\Registration\RoPS_tests";
    output_file_source_name = "heart_clean_full_res_iss_fpfh";
    output_file_target_name = "full_heart_rescaled_bis_iss_fpfh";
    output_file_ext = ".bin";
    write_point_descriptor_file(source_keypoints, hists_source, dim_descriptor, descriptor_type, output_dir, output_file_source_name, output_file_ext, 'cross_check', flip(target_source_matchings_checked, 2));
    write_point_descriptor_file(target_keypoints, hists_target, dim_descriptor, descriptor_type, output_dir, output_file_target_name, output_file_ext, 'cross_check', flip(target_source_matchings_checked, 2));
end 
 
% This script enables to visualize the colored keypoints on both the source
% mesh and the target mesh. The keypoints are colored according to their
% similarity. For that, for each keypoint descriptor we compute the L2-histogram
% distance to the other keypoints descriptor. The keypoints descrpiptor
% that are "close enough" get the same label color. If one keypoint is
% declared "close enough" to 2 keypoints of different color label, then the
% considered keypoint takes the color label of the closest keypoint among
% the two. The "close enough" is determined by the user thnks to a threshold
% parameter. Let's say that two keypoints descriptor are considered similar
% if their histograms share more than 90% similarities. Then the user must
% set the parameter "percentage_of_similarity" to 90.

% The parameters that the user have to set are : 
% - the source_mesh_filename (line 26)
% - the target_mesh_filename (line 28)
% - the source detector-descritpor file (line 64)
% - the target detector-desciptor file (line 68)
% - the percentage of similarity (line 73)

% In our example, the source is the synthetic object and the target is the
% heart object. The detector-descriptor used are ISS with SHOT (see PCL
% library if you want to compute these two by yourself). And the percentage
% of similarity is 90. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source_mesh_filename = "D:/Registration/RoPS_tests/ObjetSynthetique_simp32.ply";
[source_faces, source_pts, source_data,~] = plyread(source_mesh_filename,'tri');
target_mesh_filename = "D:/Registration/RoPS_tests/heart_synthetique.ply";
[target_faces, target_pts, target_data,~] = plyread(target_mesh_filename,'tri');

% %============================store vertices and faces into a triangular mesh============================%
source_mesh.vertices = source_pts;
source_mesh.faces = source_faces;
[source_mean_edge_length, source_std_edge_length] = compute_edges_statistics(source_mesh.vertices, source_mesh.faces);
source_mesh.resolution = source_mean_edge_length;
source_mesh.stdeviation = source_std_edge_length;
source_mesh.vertexNormals = double([source_data.vertex.nx, source_data.vertex.ny, source_data.vertex.nz]);
source_mesh.triangleNormals = compute_face_normal(source_mesh.vertices, source_mesh.vertexNormals, source_mesh.faces);
source_mesh.vertexNtriangles = get_vertex_adjacent_faces(source_mesh.faces, size(source_pts, 1));
source_mesh.triangleNtriangles = get_face_adjacent_faces(source_mesh.faces);

target_mesh.vertices = target_pts;
target_mesh.faces = target_faces;
[target_mean_edge_length, target_std_edge_length] = compute_edges_statistics(target_mesh.vertices, target_mesh.faces);
target_mesh.resolution = target_mean_edge_length;
target_mesh.stdeviation = target_std_edge_length;
target_mesh.vertexNormals = double([target_data.vertex.nx, target_data.vertex.ny, target_data.vertex.nz]);
target_mesh.triangleNormals = compute_face_normal(target_mesh.vertices, target_mesh.vertexNormals, target_mesh.faces);
target_mesh.vertexNtriangles = get_vertex_adjacent_faces(target_mesh.faces, size(target_pts, 1));
target_mesh.triangleNtriangles = get_face_adjacent_faces(target_mesh.faces);

%============================preprocessing============================%
out = preprocessingFunc(source_mesh);
source_mesh.faceCenter = out.centroid;
source_mesh.faceArea = out.area;
source_mesh.res = out.res ;

out = preprocessingFunc(target_mesh);
target_mesh.faceCenter = out.centroid;
target_mesh.faceArea = out.area;
target_mesh.res = out.res ;

%============================get keypoints with associated descriptors============================%
[source_DescriptorArray, nb_source_keypoints, nb_bins] = readDescriptorHistogram('D:/Registration/RoPS_tests/ObjetSynthetique_simp32_iss_shot.txt');
source_keypoints = (horzcat(source_DescriptorArray(:).p))';
source_hists_array = vertcat(source_DescriptorArray(:).hy);

[target_DescriptorArray, nb_target_keypoints, nb_bins] = readDescriptorHistogram('D:/Registration/RoPS_tests/heart_synthetique_iss_shot.txt');
target_keypoints = (horzcat(target_DescriptorArray(:).p))';
target_hists_array = vertcat(target_DescriptorArray(:).hy);

%============================cluster keypoints============================%
percentage_of_similarity = 90;
hists_array = [source_hists_array; target_hists_array];
[hists_array_labelled, nb_clusters] = clustering_algorithm(hists_array, percentage_of_similarity);

%============================show keypoint descriptor clustering============================%
source_labels = hists_array_labelled(1:nb_source_keypoints, 1);
visualize_keypoint_descriptors_similarity(source_mesh, source_keypoints, source_labels, nb_clusters);
target_labels = hists_array_labelled(nb_source_keypoints+1:end, 1);
visualize_keypoint_descriptors_similarity(target_mesh, target_keypoints, target_labels, nb_clusters);

%  demo_RoPS_FeatureMatching_Mesh.m
%  Author: Yulan Guo {yulan.guo@nudt.edu.cn}
%  NUDT, China & CSSE, UWA, Australia
% This function performs feature matching on two input meshes to obtain feature
% correspondences

%close all;
clc;
clear all;
flag_outlier = 1;

%keypntNum = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source_filename = "C:\Registration\RoPS_tests\heart_clean_full_res.ply";
target_filename = "C:\Registration\RoPS_tests\full_heart_rescaled_bis.ply";
%target_filename = "C:\Registration\RoPS_tests\full_heart_rescaled.ply";
[source_faces, source_pts, source_data,~] = plyread(source_filename,'tri');
[target_faces, target_pts, target_data,~] = plyread(target_filename,'tri');
%pointcloud = double(pc_source.Location);
% %============================transform a pointcloud into a triangular mesh============================%
%mesh = pointCloud2mesh(pointcloud,[0 0 1],0.4);                                         %other methods can also be used to perform triangulation
mesh.vertices = double(source_pts);
mesh.faces = source_faces;
[mean_edge_length, std_edge_length] = compute_edges_statistics(mesh.vertices, mesh.faces);
mesh.resolution = mean_edge_length;
mesh.stdeviation = std_edge_length;
mesh.vertexNormals = double([source_data.vertex.nx, source_data.vertex.ny, source_data.vertex.nz]);
mesh.triangleNormals = compute_face_normal(mesh.vertices, mesh.vertexNormals, mesh.faces);
mesh.vertexNtriangles = get_vertex_adjacent_faces(mesh.faces, size(source_pts, 1));
mesh.triangleNtriangles = get_face_adjacent_faces(mesh.faces);

%============================preprocessing============================%
out = preprocessingFunc(mesh);
mesh.faceCenter = out.centroid;
mesh.faceArea = out.area;
mesh.res = out.res ;
%============================detect keypoints============================%
% %keypoints are randomly seleted in this demo, any other 3D keypoint detection methods can be used
% keypntNum = 1500;
% temp = randperm(length(mesh.vertices));
% mesh.keypntIdx = temp(1:keypntNum);

%keypoints are obtained with ISS
% keypoints = readmatrix('C:\Registration\RoPS_tests\source_sift_keypoints.txt');
keypoints_pc = pcread('C:\Registration\RoPS_tests\heart_clean_full_res_iss_keypoints.ply');
keypoints = keypoints_pc.Location;
keypntNum = size(keypoints,1);
mesh.keypntIdx = knnsearch(mesh.vertices,keypoints);
%============================show the source mesh and its keypoints============================%
meshX = mesh;
angle = 0;%-90;
R = [1,0,0; 0,cos(angle*pi/180),sin(angle*pi/180); 0, -sin(angle*pi/180), cos(angle*pi/180)]';
meshX.vertices = mesh.vertices*R;
figure; trisurf(meshX.faces,meshX.vertices(:,1),meshX.vertices(:,2),meshX.vertices(:,3)); axis equal;
axis image; shading interp;lighting phong; view([0,0]);  hold on; colormap([1,1,1]*0.9);camlight right;hold on;axis off;
plot3(meshX.vertices(mesh.keypntIdx,1),meshX.vertices(mesh.keypntIdx,2),meshX.vertices(mesh.keypntIdx,3),'r.');
%============================extract RoPS features at the keypoints on a mesh============================%
para.RoPS_nbSize = 15*mesh.res;
para.RoPS_binSize = 5;
para.RoPS_rotaSize = 6;
mesh.LRF =  LRFforMeshFunc(mesh, mesh.keypntIdx, para.RoPS_nbSize);
disp('LRFs calculated');  
RoPS = RoPSFunc(mesh, para.RoPS_nbSize, para.RoPS_binSize, para.RoPS_rotaSize,mesh.LRF);
mesh.RoPS = RoPS;
disp(['RoPS features generated']);  
mesh1 = mesh;
mesh1Features = [];
for keypntIdx = 1:keypntNum
    temp = trans2Dto1DFunc(mesh.RoPS{keypntIdx});
    mesh1Features = [mesh1Features; temp];
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pointcloud= double(pc_target.Location);
% %============================transform a pointcloud into a triangular mesh============================%
%mesh = pointCloud2mesh(pointcloud,[0 0 1],0.4);                                         %other methods can also be used to perform triangulation
mesh.vertices = double(target_pts);
mesh.faces = target_faces;
[mean_edge_length, std_edge_length] = compute_edges_statistics(mesh.vertices, mesh.faces);
mesh.resolution = mean_edge_length;
mesh.stdeviation = std_edge_length;
mesh.vertexNormals = double([target_data.vertex.nx, target_data.vertex.ny, target_data.vertex.nz]);
mesh.triangleNormals = compute_face_normal(mesh.vertices, mesh.vertexNormals, mesh.faces);
mesh.vertexNtriangles = get_vertex_adjacent_faces(mesh.faces, size(target_pts, 1));
mesh.triangleNtriangles = get_face_adjacent_faces(mesh.faces);
%============================preprocessing============================%
out = preprocessingFunc(mesh);
mesh.faceCenter = out.centroid;
mesh.faceArea = out.area;
mesh.res = out.res ;
%============================detect keypoints============================%
% %keypoints are randomly seleted in this demo, any other 3D keypoint detection methods can be used
% keypntNum = 200;
% temp = randperm(length(mesh.vertices));
% mesh.keypntIdx = temp(1:keypntNum);

%keypoints are obtained with ISS
% keypoints = readmatrix('C:\Registration\RoPS_tests\target_sift_keypoints.txt');
keypoints_pc = pcread('C:\Registration\RoPS_tests\full_heart_rescaled_bis_iss_keypoints.ply');
keypoints = keypoints_pc.Location;
keypntNum = size(keypoints,1);
mesh.keypntIdx = knnsearch(mesh.vertices,keypoints);
%============================show the source mesh and its keypoints============================%
meshX = mesh;
angle = 0;%-90;
R = [1,0,0; 0,cos(angle*pi/180),sin(angle*pi/180); 0, -sin(angle*pi/180), cos(angle*pi/180)]';
meshX.vertices = mesh.vertices*R;
figure; trisurf(meshX.faces,meshX.vertices(:,1),meshX.vertices(:,2),meshX.vertices(:,3)); axis equal;
axis image; shading interp;lighting phong; view([0,0]);  hold on; colormap([1,1,1]*0.9);camlight right;hold on;axis off;
plot3(meshX.vertices(mesh.keypntIdx,1),meshX.vertices(mesh.keypntIdx,2),meshX.vertices(mesh.keypntIdx,3),'r.');
%============================extract RoPS features at the keypoints on a mesh============================%
para.RoPS_nbSize = 15*mesh.res;
para.RoPS_binSize = 5;
para.RoPS_rotaSize = 6;
mesh.LRF =  LRFforMeshFunc(mesh, mesh.keypntIdx, para.RoPS_nbSize);
disp('LRFs calculated');  
RoPS = RoPSFunc(mesh, para.RoPS_nbSize, para.RoPS_binSize, para.RoPS_rotaSize,mesh.LRF);
mesh.RoPS = RoPS;
disp(['RoPS features generated']);  
mesh2 = mesh;
mesh2Features = [];
for keypntIdx = 1:keypntNum
    temp = trans2Dto1DFunc(mesh.RoPS{keypntIdx});
    mesh2Features = [mesh2Features; temp];
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %============================feature matching============================%
NNDRthreshold = 1;
corNum = 0;
kdtreeMesh1Features = KDTreeSearcher(mesh1Features,'Distance','euclidean');
corPntIdx = [];

for keypntIdx1 = 1:size(mesh2Features,1)
    [idxSort,distSort] = knnsearch(kdtreeMesh1Features, mesh2Features(keypntIdx1,:),'k',2,'Distance','euclidean');
    IDX = idxSort(1);
    if distSort(1)/distSort(2)<=NNDRthreshold %&& distSort(1) < 0.02
        %disp(distSort(1));  
        corNum = corNum+1;
        corPntIdx(corNum,:) = [IDX, keypntIdx1]; % source-target pairs indices (numeroted wrt source_keypoints and target_keypoints)
        featureDis(corNum) = distSort(1);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %============================outliers removal============================%
if flag_outlier
    corPntIdx = geodesic_distance_check_matching_pairs_bis(mesh1.faces, mesh1.vertices, mesh2.faces, mesh2.vertices, mesh1.vertices(mesh1.keypntIdx,:), mesh2.vertices(mesh2.keypntIdx,:), flip(corPntIdx, 2), 10, 1.8, 6);
    corPntIdx = flip(corPntIdx,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %============================show matchings============================%
if isempty(corPntIdx)
    disp(['no matches found between the two models']);  
else
    showCorresFunc(mesh1, mesh2, mesh1.keypntIdx(corPntIdx(:,1)), mesh2.keypntIdx(corPntIdx(:,2)), [0,200,0]);
end

%============================links============================%
% %we may find more test datasets via the following links
% url = 'https://sites.google.com/site/yulanguo66/research-resources/3d-object-recognition-datasets';
% web(url,'-browser')



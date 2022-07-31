function visualize_keypoint_descriptors_similarity(mesh, keypoints, labels, nb_clusters)
% mesh : struct with at least 2 fields (vertices , faces)
% keypoints : m-by-3 matrix with keypoints coordinates
% labels : column vector of length m where the associated labels of keypoints
% descriptors are stored


cmap = hsv(max(nb_clusters,1)); 
nb_keypoints = size(keypoints,1);
meshX = mesh;
angle = 0;%-90;
R = [1,0,0; 0,cos(angle*pi/180),sin(angle*pi/180); 0, -sin(angle*pi/180), cos(angle*pi/180)]';
meshX.vertices = mesh.vertices*R;
figure; trisurf(meshX.faces,meshX.vertices(:,1),meshX.vertices(:,2),meshX.vertices(:,3)); axis equal;
axis image; shading interp;lighting phong; view([0,0]);  hold on; colormap([1,1,1]*0.9);camlight right;hold on;axis off;
for i =1:1:nb_keypoints
    label = labels(i);
    plot3(keypoints(i, 1), keypoints(i, 2), keypoints(i,3),'Color',cmap(label,:), 'Marker', '.', 'MarkerSize', 20);
end

end


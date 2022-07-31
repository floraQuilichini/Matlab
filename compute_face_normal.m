function faces_normal = compute_face_normal(pts, normal_pts, faces)
% compute face normals of a mesh. To get rid of the ambiguity on the sign
% of the normal,we use the normal of each vertex (that we already
% pre-calculated). The dot product between the face normal and the normals of the points must be positive 

% get plane equation from faces
unoriented_normal_faces = cross(pts(faces(:, 2), :) - pts(faces(:, 1), :), pts(faces(:, 3), :) - pts(faces(:, 1), :));
unoriented_normed_normal_faces = unoriented_normal_faces./sqrt(sum(unoriented_normal_faces.^(2),2));
% get mean normal orientation of the points belonging to the face
mean_face_points_normal = (normal_pts(faces(:, 1), :) + normal_pts(faces(:, 2), :) + normal_pts(faces(:, 3), :))/3;
% get sign of face normal
sign = dot(unoriented_normed_normal_faces, mean_face_points_normal, 2);
indices = (1:1:size(faces, 1))';
negative_index = indices(sign<0);
faces_normal= unoriented_normed_normal_faces;
faces_normal(negative_index, :) = - faces_normal(negative_index, :);

end


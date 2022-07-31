function vertex_adjacent_faces = get_vertex_adjacent_faces(faces, nb_vertices)
%this function returns a cell array whose each row contains the indices of
%adjacent faces of each vertex of a mesh. The vertex is identify by its
%index (eg: first row of the array will contain adjacent faces indices of
%vertex 1)

vertex_adjacent_faces = cell(nb_vertices, 1);
nb_faces = size(faces, 1);
face_indices = (1:1:nb_faces)';
for i=1:1:nb_vertices
    bool_vec = ismember(faces(:), i);
    faces_adj = bool_vec(1:nb_faces) | bool_vec(nb_faces+1:2*nb_faces) | bool_vec(2*nb_faces+1:3*nb_faces);
    vertex_adjacent_faces{i, 1} = face_indices(faces_adj, :)';
end

end


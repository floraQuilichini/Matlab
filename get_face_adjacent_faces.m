function face_adjacent_faces = get_face_adjacent_faces(faces)
%this function returns a cell array whose each row contains the indices of
%adjacent faces of each face of a mesh. The face is identify by its
%index (eg: first row of the array will contain adjacent faces indices of
%face 1)

nb_faces = size(faces, 1);
face_adjacent_faces = cell(nb_faces, 1);
face_indices = (1:1:nb_faces)';
for i=1:1:nb_faces
    face_vertex_indices = faces(i, :);
    iface_adjacent_faces = [];
    for j =1:1:3
        vertex_index = face_vertex_indices(j);
        bool_vec = ismember(faces(:), vertex_index);
        faces_adj = bool_vec(1:nb_faces-1) | bool_vec(nb_faces:2*nb_faces-2) | bool_vec(2*nb_faces-1:3*nb_faces-3);
        iface_adjacent_faces = [iface_adjacent_faces , face_indices(faces_adj, :)'];
    end
    iface_adjacent_faces = unique(iface_adjacent_faces);
    face_adjacent_faces{i,1} = iface_adjacent_faces(iface_adjacent_faces~=i);
end

end




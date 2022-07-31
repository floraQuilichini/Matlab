function save_ply_file_after_normal_normalization(input_filename, output_filename)
% this function open ply mesh given by input filename, normalizes its
% normal and save the new mesh in output_filename


[~,~,data] = plyread(input_filename,'tri');
normals = [data.vertex.nx, data.vertex.ny, data.vertex.nz];
normals_norm = sqrt(sum(normals.*normals, 2));
normals_normed = normals ./normals_norm;
data.vertex.nx = normals_normed(:, 1);
data.vertex.ny = normals_normed(:, 2);
data.vertex.nz = normals_normed(:, 3);
plywrite(data, output_filename, 'ascii');

end


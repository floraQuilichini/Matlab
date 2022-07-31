function pc_rescaled = rescale_pc(pc_filename, scale_coeffs, varargin)


numvararg = length(varargin);
if (numvararg == 1)
    output_flag = 1;
    output_file = varargin{:};
else
    output_flag = 0;
end

[path, name, ext] = fileparts(pc_filename);
if strcmp(ext, '.ply')
    [tri,pts,data] = plyread(pc_filename);
else
    pc = pcread(pc_filename);
    pts = pc.Location;
end


scale_matrix = eye(3,3);
scale_matrix(1, 1) = scale_coeffs(1);
scale_matrix(2, 2) = scale_coeffs(2);
scale_matrix(3, 3) = scale_coeffs(3);

pts_rescaled = pts*scale_matrix;

if strcmp(ext, '.ply') && ~isempty(data.face.vertex_indices)
    data.vertex.x = pts_rescaled(:, 1);
    data.vertex.y = pts_rescaled(:, 2);
    data.vertex.z = pts_rescaled(:, 3);
    pc_rescaled = data;
elseif strcmp(ext, '.ply')
    pc_normals = [data.vertex.nx data.vertex.ny data.vertex.nz];
    pc_rescaled = pointCloud(pts_rescaled, 'Normal', pc_normals);
else
    pc_rescaled = pointCloud(pts_rescaled, 'Color', pc.Color, 'Normal', pc.Normal, 'Intensity', pc.Intensity);
end

if output_flag
    if strcmp(ext, '.ply')&& ~isempty(data.face.vertex_indices)
        plywrite(data,output_file,'ascii');
    else
        pcwrite(pc_rescaled, output_file);
    end
end

end


function [pts_transformed, normals_transformed] = apply_transform_to_pc(pc_filename, theta, rot_axis, trans, scale_coeffs, varargin)
% this function computes a rigid transform (with rotation, translation and
% scale parameter) applied to the point cloud located in "pc_filename".
% This file must have a ".pcd" or ".ply" extension
% The transform parameters are : 
% - theta (the angle of rotation)
% - rot_axis (the axis of rotation)
% - trans (1-by-3 vector of translation)
% - scale_coeffs (1-by-3 vector with scale coefficients) 
% The user can save the transformed point cloud by adding an extra
% parameter (which is the output filename where to save the transformed point cloud).


numvararg = length(varargin);
if numvararg == 1
    flag_save_file = 1;
    output_filename = varargin{:};
else
    flag_save_file = 0;
end


normals = [];
normals_transformed = [];

% read pc
[path, name, ext] = fileparts(pc_filename);
if strcmp(ext, '.ply')
    [tri, pts, data] = plyread(pc_filename, 'tri');
    % get vertex attributes (ie normals if any)
    if numel(fieldnames(data.vertex)) > 3
        % get normals
        normals(:, 1) = data.vertex.nx;
        normals(:, 2) = data.vertex.ny;
        normals(:, 3) = data.vertex.nz;
        % and norm them
        norm = sqrt(sum(normals.*normals, 2));
        if (norm ~=0.0)    
            normals = normals./norm;
        end
    end      
elseif strcmp(ext, '.pcd')
    pc = pcread(pc_filename);
    pts = pc.Location;
    % get vertex attributes (ie normals if any)
    if ~isempty(pc.Normal)
        % get normals
        normals = pc.Normal;
        % and norm them
        norm = sqrt(sum(normals.*normals, 2));
        if (norm ~=0)
            normals = normals./norm;
        end
    end
else
    error('file must be ply or pcd');
end


% compute transform
T = compute_transform_matrix(theta, rot_axis, trans, scale_coeffs);
% and apply it to points
pts_transformed = applyTtoPc(pts,T);
% and to normals (if any)
if ~isempty(normals)
    rot = compute_rotation_matrix(theta, rot_axis);
    normals_transformed = normals*transpose(rot);
end


% write in file 
if (flag_save_file)
    if strcmp(ext, '.ply') % ply case
        % write points
        data_transformed.vertex.x = pts_transformed(:, 1);
        data_transformed.vertex.y = pts_transformed(:, 2);
        data_transformed.vertex.z = pts_transformed(:, 3);
        % write normals (if any)
        if (~isempty(normals))
            data_transformed.vertex.nx = normals_transformed(:, 1);
            data_transformed.vertex.ny = normals_transformed(:, 2);
            data_transformed.vertex.nz = normals_transformed(:, 3);
        end
        % write faces (if any)
        if (~isempty(tri))
            nb_faces = size(tri, 1);
            data_transformed.face.vertex_indices =  mat2cell(tri-1,ones(1, nb_faces)); % the tri-1 is because ply face index begins at 0 whereas tri face begins at 1
        end
        plywrite(data_transformed,output_filename,'ascii');
    else    % pcd case
        % write points
        ptCloud = pointCloud(pts_transformed);
        % write normals (if any)
        if (~isempty(normals))
            ptCloud.Normal = normals_transformed;
        end
        pcwrite(ptCloud, output_filename,'Encoding', 'ascii');
    end
end

end


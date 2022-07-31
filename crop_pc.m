function upper_pts = crop_pc(pc_filename, plane, ratio, output_filename)
%   this function enables the user to divide a point cloud (pc) into 2
%   smaller point clouds (pc_up, pc_low). The point cloud is cut along a
%   plane ('XY' or 'XZ' or 'YZ') specified by the user. The third input
%   parameter is to specify where to place the cutting plane. If the user
%   enters 0, then all the points will be in the upper point cloud. If he 
%   enters 1, then all the points will be in the lower point cloud. If he 
%   enters alpha (0<alpha<1), then all the points with the relative coordinate 
%   upper than (1-alpha)*min_coord + alpha*max_coord will belong to the 
%   upper point cloud and the others to the lower point cloud 
%   
[Data, ~] = plyread(pc_filename);
pc = pcread(pc_filename);

if strcmp(plane, 'XY') || strcmp(plane, 'YX')
    range = pc.ZLimits; 
    index_c = 3;
    val = [0; 0; range(1, 1) + ratio*(range(1, 2) - range(1, 1))];
elseif strcmp(plane, 'XZ')|| strcmp(plane, 'ZX')
    range = pc.YLimits; 
    index_c = 2;
    val = [0; range(1, 1) + ratio*(range(1, 2) - range(1, 1)); 0];
elseif strcmp(plane, 'YZ') || strcmp(plane, 'ZY')
    range = pc.XLimits; 
    index_c = 1;
    val = [range(1, 1) + ratio*(range(1, 2) - range(1, 1)); 0; 0];
end

pts = [Data.vertex.x, Data.vertex.y, Data.vertex.z];
if numel(fieldnames(Data.vertex))> 3
    normals = [Data.vertex.nx, Data.vertex.ny, Data.vertex.nz];
end
% apply PCA to find the eigen vector base

    % center pts
mean_pts = mean(pts, 1);
pts_centered = pts - repmat(mean_pts, pc.Count, 1);

    % compute covariance
C = cov(pts_centered);

    % get eigen vectors
[V, ~] = eig(C);

    % compute the coordinates in eigen vector basis
newpts = V * pts';
newpts = newpts';

% crop point cloud 
    % update value in the new basis
new_val = V*val;
    % get points indices to keep
Data_upper.vertex = [];
Data_upper.face = [];
counter = 1;
counter2 = 1;
new_face_index = zeros(pc.Count, 1);
used_faces = [0 0 0];
for i = 1:pc.Count
    if newpts(i, index_c) > new_val(index_c)
        % get faces to keep
        for j= 1:1:size(Data.face.vertex_indices, 1)
            face = [Data.face.vertex_indices{j, 1}];
            if ismember(i-1, face)
                if ~ismember(face, used_faces, 'rows')
                    if ~new_face_index(face(1) + 1)
                        upper_pts(counter, :) = pts(face(1)+1, :);
                        if numel(fieldnames(Data.vertex))> 3
                            upper_normals(counter, :) = normals(face(1)+1, :);
                        end
                        new_face_index(face(1) + 1) = counter;
                        counter = counter +1;
                    end
                    if ~new_face_index(face(2) + 1)
                        upper_pts(counter, :) = pts(face(2)+1, :);
                        if numel(fieldnames(Data.vertex))> 3
                            upper_normals(counter, :) = normals(face(2)+1, :);
                        end
                        new_face_index(face(2) + 1) = counter;
                        counter = counter +1;
                    end
                    if ~new_face_index(face(3) + 1)
                        upper_pts(counter, :) = pts(face(3)+1, :);
                        if numel(fieldnames(Data.vertex))> 3
                            upper_normals(counter, :) = normals(face(3)+1, :);
                        end
                        new_face_index(face(3) + 1) = counter;
                        counter = counter +1;
                    end
                    Data_upper.face.vertex_indices(1, counter2) = {new_face_index(face + [1, 1, 1])'- [1 1 1]};
                    used_faces(counter2, :) = face;
                    counter2 = counter2 +1;
                end
            end
        end
    end
end

    % get upper points and normals
Data_upper.vertex.x = upper_pts(:, 1);
Data_upper.vertex.y = upper_pts(:, 2);
Data_upper.vertex.z = upper_pts(:, 3);
if numel(fieldnames(Data.vertex))> 3
    Data_upper.vertex.nx = upper_normals(:, 1);
    Data_upper.vertex.ny = upper_normals(:, 2);
    Data_upper.vertex.nz = upper_normals(:, 3);
end

% save pc
plywrite(Data_upper, output_filename,'ascii');

end

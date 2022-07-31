function data = reduce_data(data,PointCloud)
%reduce points in data by taking Pts subset

% Pts
Pts = PointCloud.Location;

% original Points
old_X = data.vertex.x; 
old_Y = data.vertex.y;
old_Z = data.vertex.z;


% original normals
old_nX = data.vertex.nx; 
old_nY = data.vertex.ny;
old_nZ = data.vertex.nz;
old_normals = [old_nX; old_nY; old_nZ];


% reduce data
Lia = ismember([old_X; old_Y; old_Z],Pts,'rows');
normals = old_normals(Lia > 0, :);


data.vertex.x = Pts(:, 1);
data.vertex.y = Pts(:, 2);
data.vertex.z = Pts(:, 3);
data.vertex.nx = normals(1, :);
data.vertex.ny = normals(2, :);
data.vertex.nz = normals(3, :);

end


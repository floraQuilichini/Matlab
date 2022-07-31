function pointCloud_target_transformed = applyTransform(target, T)
%This function do the registration of a point cloud source on a point cloud
%target. The parameter T is the computed matrix transform to
%map pc_target on pc_source. In real, pc_source represents the data acquired
%with the hololens and pc_target the data acquired with the scan. 
% the function returns the source point cloud registered on the target
% point cloud. 

if isa(target, 'char')
    pc_target_filename = target;
    ptCloud_target = pcread(pc_target_filename);
    pc_target_coord = ptCloud_target.Location;
elseif isa(target, 'pointCloud')
    ptCloud_target = target;
    pc_target_coord = ptCloud_target.Location;
elseif isa(target, 'numeric')
    pc_target_coord = target;
else
    error("wrong input data type");
end

% recalage target vers source
[l, c] = size(pc_target_coord);
pc_target_homogenous_coord = ones(l, c+1);
pc_target_homogenous_coord(:, 1:3) = pc_target_coord;
pc_target_homogenous_coord_transformed = pc_target_homogenous_coord*transpose(T);

pointCloud_target_transformed = pointCloud(single(pc_target_homogenous_coord_transformed(:, 1:3)));

end


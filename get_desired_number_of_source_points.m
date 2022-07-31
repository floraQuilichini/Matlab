function [pc_source_downsampled] = get_desired_number_of_source_points(original_source_file, vsa_source_file, nb_downsampled_points, output_filename)

pc_source =  pcread(original_source_file);
pc_vsa = pcread(vsa_source_file);
pc_vsa_coords = pc_vsa.Location;
%region_center_coordinates = pc_vsa_coords(1:nb_downsampled_points, :);
anchors_coordinates = pc_vsa_coords(nb_downsampled_points + 1:end, :);

% keep anchors first
[~, subpc_with_anchors] = get_pc2_closest_points_in_pc1(pointCloud(anchors_coordinates), pc_source);
nb_corresponding_anchors = subpc_with_anchors.Count;
if nb_corresponding_anchors > nb_downsampled_points
    indices = randi(nb_corresponding_anchors, nb_downsampled_points, 1);
    subpc_with_anchors_coords = subpc_with_anchors.Location;
    if isempty(subpc_with_anchors.Normal)
        pc_source_downsampled = pointCloud(subpc_with_anchors_coords(indices, :));
    else
        subpc_with_anchors_normals = subpc_with_anchors.Normal;
        subpc_with_anchors_normals = subpc_with_anchors_normals(indices, :);
        pc_source_downsampled = pointCloud(subpc_with_anchors_coords(indices, :), 'Normal', subpc_with_anchors_normals);
    end
else
    pc_source_downsampled_coords = subpc_with_anchors.Location;

    % and then, complete the remaining points with region center points
        % first remove region points that correspond to the same point as
        % anchors points in source pc
        [~, all_subpc] = get_pc2_closest_points_in_pc1(pc_vsa,pc_source);
        region_center_remaining_coordinates = setdiff(all_subpc.Location,subpc_with_anchors.Location,'rows');
        % then compute remaining number of needed points
        nb_remaining_points = nb_downsampled_points - subpc_with_anchors.Count;
        if nb_remaining_points > size(region_center_remaining_coordinates, 1)
            disp('there are not enough different points to achieve the number of downsampled points you want');
            fprintf('instead of having %d points, your point cloud will have %d points', nb_downsampled_points, all_subpc.Count);
            pc_source_downsampled = all_subpc;
        else
            % then pick randomly the number of points needed to achieve
            % nb_downsampled_points
            remaining_indices = randi(size(region_center_remaining_coordinates, 1), nb_remaining_points,1);
            point_coords_to_add = region_center_remaining_coordinates(remaining_indices, :);
            % add points to pc_source_downsampled
            pc_source_downsampled_coords = [pc_source_downsampled_coords; point_coords_to_add];
            if isempty(all_subpc.Normal)
                pc_source_downsampled = pointCloud(pc_source_downsampled_coords);
            else
                subpc_with_anchors_normals = subpc_with_anchors.Normal;
                region_center_remaining_normals = setdiff(all_subpc.Normal,subpc_with_anchors.Normal,'rows');
                normals_to_add = region_center_remaining_normals(remaining_indices, :);
                pc_source_downsampled_normals = [subpc_with_anchors_normals; normals_to_add];
                pc_source_downsampled = pointCloud(pc_source_downsampled_coords, 'Normal', pc_source_downsampled_normals);
            end
        end
end
% save 
pcwrite(pc_source_downsampled, output_filename,'Encoding','ascii');

end


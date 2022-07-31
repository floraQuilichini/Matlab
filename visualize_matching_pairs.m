function visualize_matching_pairs(pc_target_FPFH_filename, pc_source_FPFH_filename, index_matching_target_to_source)

if isempty(index_matching_target_to_source)
    disp('there is no matching points');
else

    %% sanity check
    pc_target_FPFH = pcread(pc_target_FPFH_filename);
    pc_source_FPFH = pcread(pc_source_FPFH_filename);

    % check that source and target point  matrices have the same dimension
    pcCoordsTargetFPFH = pc_target_FPFH.Location;
    pcCoordsSourceFPFH = pc_source_FPFH.Location;
    [~, c_target] = size(pcCoordsTargetFPFH);
    [~, c_source] = size(pcCoordsSourceFPFH);
    if c_target ~= 3 || c_source ~= 3
        error('source and target points must be 3 dimension');
    end
    
    % resize index_matching_target_to_source to a n-by-2 matrix
    index_matching_target_to_source = index_matching_target_to_source';  % we suppose that index_matching_target_to_source is a 2-by-n matrix at the begining
   

    %% compare groundtruth to computed index_matching pairs
    disp(index_matching_target_to_source)
    matching_points_target = pcCoordsTargetFPFH(index_matching_target_to_source(:, 1), :);
    matching_points_source = pcCoordsSourceFPFH(index_matching_target_to_source(:, 2), :);
    

    %% display point cloud
    figure;
        % display source and target point cloud
    pcshow(pcCoordsSourceFPFH, [0 0 1]); % source is in blue color
    hold on
    pcshow(pcCoordsTargetFPFH, [0 1 1]); % target is in cyan color
        % display matching points
    x_coords = zeros(1, 2);
    y_coords = zeros(1, 2);
    z_coords = zeros(1, 2);
    for i=1:1:size(index_matching_target_to_source, 1)
        hold on
        x_coords(1) = matching_points_target(i, 1);
        y_coords(1) = matching_points_target(i, 2);
        z_coords(1) = matching_points_target(i, 3);
        x_coords(2) = matching_points_source(i, 1);
        y_coords(2) = matching_points_source(i, 2);
        z_coords(2) = matching_points_source(i, 3);
        plot3(x_coords, y_coords, z_coords, '-*', 'Color', 'y','MarkerSize', 2);

    end
    hold off

    % save figure
    [path, name_target, ~] = fileparts(pc_target_FPFH_filename);
    [~, name_source, ~] = fileparts(pc_source_FPFH_filename);
    savefig(fullfile(path, strcat(name_source, '_', name_target, '_matching_visualization.fig')));

end
end



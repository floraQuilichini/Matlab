function visualizeFPFHPoints(pcTarget_filename, pcSource_filename, pc_target_FPFH_filename, pc_source_FPFH_filename, index_matching_target_to_source, Tfilename, max_scale, source_trans, target_trans)
% this function is used to visualize the matching of source points to
% target points in wich we have computed the FPFH
% the two first input parameters are the two point clouds. We suppose that
% points clouds have already been aligned; the recovery transform (rot + trans)
% may have already been applied but the point clouds should still be
% centered and normalized
% the two following ones are point clouds composed of points taken for computing FPFH
% the last one is the index matching list (source to target) of dimension n
% by 2 (or 2 by n)
% it outputs a figure of the matched points


if isempty(index_matching_target_to_source)
    disp('there is no matching points');
else

    %% sanity check

    pcTarget = pcread(pcTarget_filename);
    pcSource = pcread(pcSource_filename);
    pc_target_FPFH = pcread(pc_target_FPFH_filename);
    pc_source_FPFH = pcread(pc_source_FPFH_filename);


    % check that points are dimension 3
    pcCoordsTarget = pcTarget.Location;
    pcCoordsSource = pcSource.Location;
    c_target = size(pcCoordsTarget, 2);
    c_source = size(pcCoordsSource, 2);
    if c_target ~= 3 || c_source ~= 3
        error('source and target point clouds must be 3 dimension');
    end

    % check that source and target point  matrices have the same dimension
    pcCoordsTargetFPFH = pc_target_FPFH.Location;
    pcCoordsSourceFPFH = pc_source_FPFH.Location;
    [~, c_target] = size(pcCoordsTargetFPFH);
    [~, c_source] = size(pcCoordsSourceFPFH);
    if c_target ~= 3 || c_source ~= 3
        error('source and target points must be 3 dimension');
    end

    % check that index matching list have the right size
    [l_matching, c_matching] = size(index_matching_target_to_source);
    if (c_matching > l_matching && l_matching ~= 1)
        index_matching_target_to_source = index_matching_target_to_source'; % index list is n x 2 matrix
        [l_matching, c_matching] = size(index_matching_target_to_source);
    elseif  c_matching == 1
        index_matching_target_to_source = index_matching_target_to_source'; % case 1 x 2 matrix
        [l_matching, c_matching] = size(index_matching_target_to_source);
    end
    if c_matching ~= 2
        disp(c_matching);
        disp(l_matching);
        error('matching index list must be a n x 2 matrix (or a 2 x n matrix)');
    end

    if source_trans == 0
        source_trans = [0 0 0];
    end

    if target_trans == 0
        target_trans = [0 0 0];
    end

    %% get groundtruth pairs
    groundtruth_pairs = computeTrueMatching(pc_target_FPFH_filename, pc_source_FPFH_filename, Tfilename, max_scale, source_trans, target_trans);

    %% compare groundtruth to computed index_matching pairs
    index_matching_target_to_source = sortrows(index_matching_target_to_source);
    remaining_groundtruth_pairs = groundtruth_pairs(index_matching_target_to_source(:, 1), :);
        % get inliers and outliers
    inliers_indexes = index_matching_target_to_source(index_matching_target_to_source(:, 2) == remaining_groundtruth_pairs(:, 2), :);
    outliers_indexes = remaining_groundtruth_pairs(index_matching_target_to_source(:, 2) ~= remaining_groundtruth_pairs(:, 2), :);
        % remove from outliers points of the groundtruth that don't
        % have a match
    true_outliers_indexes = outliers_indexes(outliers_indexes(:, 3) == 1, 1:2);
    no_matched_indexes = outliers_indexes(outliers_indexes(:, 3) == 0, 1:2);


    %%  translate target point clouds (to not have the two point clouds very close to each other)
    trans = [2, 0, 0];
    pcCoordsTargetTranslated = pcCoordsTarget + repmat(trans, size(pcCoordsTarget, 1), 1);
    pcCoordsTargetFPFHTranslated = pcCoordsTargetFPFH + repmat(trans, size(pcCoordsTargetFPFH, 1), 1);
    %pcTargetTranslated = pointCloud(pcCoordsTargetTranslated);

    %% display point cloud
    figure;
        % display source and target point cloud
    pcshow(pcCoordsSource, [0 0 1]); % source is in blue color
    %pcshow(pcCoordsSourceFPFH, [0 0 1]); % source is in blue color
    hold on
    pcshow(pcCoordsTargetTranslated, [0 1 1]); % target is in cyan color
    %pcshow(pcCoordsTargetFPFHTranslated, [0 1 1]); % target is in cyan color
        % display FPFH points
    x_coords = zeros(1, 2);
    y_coords = zeros(1, 2);
    z_coords = zeros(1, 2);
        % display inliers
    for i=1:1:size(inliers_indexes, 1)
        hold on
        x_coords(1) = pcCoordsTargetFPFHTranslated(inliers_indexes(i, 1), 1);
        y_coords(1) = pcCoordsTargetFPFHTranslated(inliers_indexes(i, 1), 2);
        z_coords(1) = pcCoordsTargetFPFHTranslated(inliers_indexes(i, 1), 3);
        x_coords(2) = pcCoordsSourceFPFH(inliers_indexes(i, 2), 1);
        y_coords(2) = pcCoordsSourceFPFH(inliers_indexes(i, 2), 2);
        z_coords(2) = pcCoordsSourceFPFH(inliers_indexes(i, 2), 3);
        plot3(x_coords, y_coords, z_coords, '-*', 'Color', 'g','MarkerSize', 2);
    end
        % display true outliers
    for i=1:1:size(true_outliers_indexes, 1)
        hold on
        x_coords(1) = pcCoordsTargetFPFHTranslated(true_outliers_indexes(i, 1), 1);
        y_coords(1) = pcCoordsTargetFPFHTranslated(true_outliers_indexes(i, 1), 2);
        z_coords(1) = pcCoordsTargetFPFHTranslated(true_outliers_indexes(i, 1), 3);
        x_coords(2) = pcCoordsSourceFPFH(true_outliers_indexes(i, 2), 1);
        y_coords(2) = pcCoordsSourceFPFH(true_outliers_indexes(i, 2), 2);
        z_coords(2) = pcCoordsSourceFPFH(true_outliers_indexes(i, 2), 3);
        plot3(x_coords, y_coords, z_coords, '-*', 'Color', 'r','MarkerSize', 2);
    end
        % display "outliers" that don't have a groundtruth match
    for i=1:1:size(no_matched_indexes, 1)
        hold on
        x_coords(1) = pcCoordsTargetFPFHTranslated(no_matched_indexes(i, 1), 1);
        y_coords(1) = pcCoordsTargetFPFHTranslated(no_matched_indexes(i, 1), 2);
        z_coords(1) = pcCoordsTargetFPFHTranslated(no_matched_indexes(i, 1), 3);
        x_coords(2) = pcCoordsSourceFPFH(no_matched_indexes(i, 2), 1);
        y_coords(2) = pcCoordsSourceFPFH(no_matched_indexes(i, 2), 2);
        z_coords(2) = pcCoordsSourceFPFH(no_matched_indexes(i, 2), 3);
        plot3(x_coords, y_coords, z_coords, '-*', 'Color', 'y','MarkerSize', 2);
    end

    hold off


    % save figure
    [path, name_target, ~] = fileparts(pc_target_FPFH_filename);
    [~, name_source, ~] = fileparts(pc_source_FPFH_filename);
    savefig(fullfile(path, strcat(name_source, '_', name_target, '_matching_visualization.fig')));

end
end


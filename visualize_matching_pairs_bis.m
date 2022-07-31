function visualize_matching_pairs_bis(pc_source_filename, pc_target_filename, matching_pairs_text_file, min_source_scale, min_target_scale, base, se, transform, varargin)


    %% get optional parameters
    numvararg = length(varargin);
    if (numvararg == 1)
        flag = 1;
        output_path = varargin{:};
    else
        flag = 0;
    end
    outlier_flag = 0;

    %% sanity check
%     pc_target = pcread(pc_target_filename);
%     pc_source = pcread(pc_source_filename);
    [source_faces, source_pts, source_data,~] = plyread(pc_source_filename,'tri');
    [target_faces, target_pts, target_data,~] = plyread(pc_target_filename,'tri');

    % check that source and target point  matrices have the same dimension
%     target_pts = pc_target.Location;
%     source_pts = pc_source.Location;
    [~, c_target] = size(target_pts);
    [~, c_source] = size(source_pts);
    if c_target ~= 3 || c_source ~= 3
        error('source and target points must be 3 dimension');
    end
    
        %% get good shifts
    mean_shift = - log(se/(min_target_scale/min_source_scale))/log(base);
    
    %% load data
    delimiterIn = ' ';
    headerlinesIn = 0;
    data = importdata(matching_pairs_text_file,delimiterIn,headerlinesIn);
    
    %% get best pairs matching
    %best_matchings = data(3:3:end, 1:6);
    best_matchings = data(:, 1:6);
    
    %% get good scale estimation
    scales_est = data(:, 7);
    mean_shift_est = mean(scales_est);
    std_shift_est = std(scales_est);
    good_scales_ind = (abs(scales_est - mean_shift_est) <= std_shift_est*0.5);
    %good_scales_ind = (abs(scales_est - mean_shift) <= 5);
    
    %% get good pairs with good scale and correlation values
    %best_matchings = best_matchings(data(3:3:end, 8)==1 & good_scales_ind(3:3:end), :);
    best_matchings = best_matchings(data(:, 8)==1 & good_scales_ind(:), :);
    %best_matchings = best_matchings(good_scales_ind(:), :);
    matching_points_target = best_matchings(:, 1:3);
    matching_points_source = best_matchings(:, 4:6);
    
    %% remove outliers
    if outlier_flag
        pairs_target_source = [(1:1:size(matching_points_target, 1))', (1:1:size(matching_points_target, 1))'];
        target_source_matchings_checked = geodesic_distance_check_matching_pairs_bis(source_faces, source_pts, target_faces, target_pts, matching_points_source, matching_points_target, pairs_target_source, 5, 1.8, 3);
    end
    %% apply registration
    source_pts_registered = [source_pts, ones(size(source_pts, 1), 1)]*transform';
    source_pts_registered = source_pts_registered(:, 1:3);
    matching_points_source_registered = [matching_points_source, ones(size(matching_points_source, 1), 1)]*transform';
    matching_points_source_registered = matching_points_source_registered(:, 1:3);

    %% display point cloud
        % show point cloud
%     figure;
%         % display source and target point cloud
%     pcshow(source_pts_registered, [0 0 1]); % source is in blue color
%     hold on
%     pcshow(target_pts, [0 1 1]); % target is in cyan color
%         % display matching points
%     x_coords = zeros(1, 2);
%     y_coords = zeros(1, 2);
%     z_coords = zeros(1, 2);
%     for i=1:1:size(matching_points_source_registered, 1)
%         hold on
%         x_coords(1) = matching_points_target(i, 1);
%         y_coords(1) = matching_points_target(i, 2);
%         z_coords(1) = matching_points_target(i, 3);
%         x_coords(2) = matching_points_source_registered(i, 1);
%         y_coords(2) = matching_points_source_registered(i, 2);
%         z_coords(2) = matching_points_source_registered(i, 3);
%         plot3(x_coords, y_coords, z_coords, '-*', 'Color', 'y','MarkerSize', 2);
% 
%     end
%     hold off
    
        % show mesh
    source_mesh.vertices = source_pts_registered;
    source_mesh.faces = source_faces;
    target_mesh.vertices = target_pts;
    target_mesh.faces = target_faces;
    if outlier_flag
        target_mesh.keypnt= matching_points_target;
        source_mesh.keypnt= matching_points_source;
        showCorresFunc_bis(source_mesh, target_mesh, target_source_matchings_checked(:, 2), target_source_matchings_checked(:, 1), [0,200,0]);
    else
        source_matchings_idx = knnsearch(source_pts,matching_points_source);
        target_matchings_idx = knnsearch(target_pts,matching_points_target);
        showCorresFunc(source_mesh, target_mesh, source_matchings_idx, target_matchings_idx, [0,200,0]);
    end

    % save figure
    if flag
        [~, name_target, ~] = fileparts(pc_target_filename);
        [~, name_source, ~] = fileparts(pc_source_filename);
        savefig(fullfile(output_path, strcat(name_source, '_', name_target, '_matching_visualization.fig')));
    end

end





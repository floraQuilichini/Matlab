function pairs_index_target_source = computeTrueMatching(pc_FPFH_target_filename, pc_FPFH_source_filename, Tfilename, max_scale, source_trans, target_trans)
% function that compute the correct matching of the point clouds ource and
% target used to compute the FPFH
% to do so, we need to indicate the transform we applied to generate our
% target point cloud. Then, we only have to apply the inverse
% transformation on the pc_FPFH_target and compute the L2 point cloud to
% point cloud distance between the pc_FPFH_target and Pc_FPFH_source. 
% The points of pc_FPFH_source that minimize the distance are taken into
% the pairs of correspondence

trueT = importdata(Tfilename);
pc_FPFH_source = pcread(pc_FPFH_source_filename);
pcCoordsSource = pc_FPFH_source.Location;
pcCoordsSource_rescaled = max_scale*(pcCoordsSource) + repmat(source_trans, size(pcCoordsSource, 1), 1);
pc_FPFH_target = pcread(pc_FPFH_target_filename);
pcCoordsTarget = pc_FPFH_target.Location;
pcCoordsTarget_rescaled = max_scale*(pcCoordsTarget) + repmat(target_trans, size(pcCoordsTarget, 1), 1);

% % sort source and target point along x_coord (then y_coord, then z_coords)
% pcCoordsSource = sortrows(pcCoordsSource, 1);
% pcCoordsTarget = sortrows(pcCoordsTarget, 1);


% apply transform on pc_FPFH_target
pointCloud_target_transformed = applyTransform(pcCoordsTarget_rescaled, inv(trueT));
pcCoordsTargetTrans = pointCloud_target_transformed.Location;

% compute pairs
    % from source to target
pairs_index_target_source = zeros(size(pcCoordsTarget_rescaled, 1), 3);
pairs_index_target_source(:, 1) = (1:1:size(pcCoordsTarget_rescaled, 1))';
for i=1:1:size(pcCoordsTarget_rescaled, 1)
        [min_d_source, index_source] = min(L2_distance(pcCoordsSource_rescaled, pcCoordsTargetTrans(i, :)));
        pairs_index_target_source(i, 2) = index_source;
end
    % symmetric operation from source to target
for i=1:1:size(pcCoordsTarget_rescaled, 1)
        index_source = pairs_index_target_source(i, 2);
        [min_d_target, index_target] = min(L2_distance(pcCoordsTargetTrans, pcCoordsSource_rescaled(index_source, :)));
            % cross check
        if index_target == i
            pairs_index_target_source(i, 3) = 1;
        end    
end
           

% % visualize result
% visualizeFPFHPoints(pc_FPFH_target, pc_FPFH_source, pc_FPFH_target, pc_FPFH_source, pairs_index_target_source);


end


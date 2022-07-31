function [pair_indices, cross_check_pair_indices] = cell_compute_similarity(descriptors_source, descriptors_target, w, alpha, nb_samples, varargin)


numvararg = length(varargin);
if numvararg ==1
    flag_cross_check = varargin{:};
elseif numvararg ==2
    flag_cross_check = varargin{1};
    flag_target = varargin{2};
else
    flag_cross_check = 0;
end


nb_points_source = size(descriptors_source, 1);
nb_points_target = size(descriptors_target, 1);

if numvararg <2
    if nb_points_source >= nb_points_target
        flag_target = 1;
    else
        flag_target = 0;
    end
end
        % stack descriptors (in order to compare each source point with
        % each target point)
if ~flag_target   % compare each source point with target points
    descriptors_target_stacked = repmat(descriptors_target, [nb_points_source 1 1]);
    descriptors_source_stacked = repelem(descriptors_source, nb_points_target, ones(1, 3), ones(1, nb_samples));
else  % compare each target point with source points
    descriptors_source_stacked = repmat(descriptors_source, [nb_points_target 1 1]);
    descriptors_target_stacked = repelem(descriptors_target, nb_points_source, ones(1, 3), ones(1, nb_samples));
end

        % compute diff
diff = descriptors_target_stacked - descriptors_source_stacked;
 
            
    % like in the paper --> search for max similarity but in a smaller
    % scale range
    
diss = sum(repmat(w', [nb_points_source*nb_points_target 1 nb_samples]).*diff.^2, 2);
sim = 1-tanh(alpha*diss);
Dsigma = squeeze(sum(sim, 3))';
if flag_target
    [pair_max_sigma, source_indices] = max(reshape(Dsigma, nb_points_source, nb_points_target));
    
    % cross check
    if flag_cross_check
        cross_check_target_indices = zeros(1, nb_points_target);
        selected_descriptors_source = descriptors_source(source_indices, :, :);
        pair_indices = cell_compute_similarity(selected_descriptors_source, descriptors_target, w, alpha, nb_samples, 0, 0);
        for i=1:1:size(pair_indices, 1)
            if pair_indices(i, 2) == i
                cross_check_target_indices(i) = i;
            end
        end
        cross_check_target_indices(cross_check_target_indices==0)=[];
        cross_check_pair_indices = [source_indices(cross_check_target_indices) ; cross_check_target_indices]';
    end
    
    pair_indices = [source_indices; (1:1:nb_points_target)]';
    
else
    [pair_max_sigma, target_indices] = max(reshape(Dsigma, nb_points_target, nb_points_source));
    
    % cross check
    if flag_cross_check
        cross_check_source_indices = zeros(1, nb_points_source);
        selected_descriptors_target = descriptors_target(target_indices, :, :);
        pair_indices = cell_compute_similarity(descriptors_source, selected_descriptors_target, w, alpha, nb_samples, 0, 1);
        for i=1:1:size(pair_indices, 1)
            if pair_indices(i, 1) == i
                cross_check_source_indices(i) = i;
            end
        end
    cross_check_source_indices(cross_check_source_indices==0)=[];
    cross_check_pair_indices = [cross_check_source_indices; target_indices(cross_check_source_indices)]';
    end
    
     pair_indices = [(1:1:nb_points_source); target_indices]';
end


end


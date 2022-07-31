function [lag, m_base, max_sim] = cell_shift_estimation(min_scale, max_scale, nb_samples, source_queries, target_queries, source_pts, target_pts, source_normals, target_normals, alpha, varargin)
%This function is used to estimate the shift between profiles of two GLS
%descriptor computed in p1_queries and p2_queries. Having the shift will enable us, in a 
%further step, to compute the relative scale between Pts_1 and Pts_2
% (we assume that p1_queries belong to source and p2_queries to target)
% It returns the oriented lag (shift) from source to target profiles

flag = 1;


numvararg = length(varargin);
if numvararg == 3
    [w_tau, w_kappa, w_phi] = varargin{:};
else
    w_tau = 1;
    w_kappa = 1;
    w_phi =1;
end


nb_query_points_source  = size(source_queries, 1);
nb_query_points_target  = size(target_queries, 1);



% first, we need to compute our GLS descriptor in a logarithmic base
    % compute log base
m_base = (max_scale/min_scale).^(1/(nb_samples-1));
display(m_base)
min_log_scale = log(min_scale)/log(m_base);
max_log_scale = log(max_scale)/log(m_base);
display(min_log_scale)
display(max_log_scale)

    % initialize scales
k = (0:1:nb_samples-1);
scales = m_base.^(k)*min_scale;

    % compute profiles
        % on all target points
[tau_t_profiles, ~, kappa_t_profiles, phi_t_profiles] = cell_compute_GLS_descriptor(target_queries, scales, target_pts, target_normals, 'Multiscale');        
        % on selected source points       
[tau_s_profiles, ~, kappa_s_profiles, phi_s_profiles] = cell_compute_GLS_descriptor(source_queries, scales, source_pts, source_normals, 'Multiscale');


% find max argument of similarity function  (obtained when cross-correlation is maximal)

    % compute dissimilarity
        % build descriptorsi
descriptors_source(:,1, :) = tau_s_profiles;
descriptors_source(:,2, :) = kappa_s_profiles;
descriptors_source(:,3, :) = phi_s_profiles;
descriptors_target(:,1, :) = tau_t_profiles;
descriptors_target(:,2, :) = kappa_t_profiles;
descriptors_target(:,3, :) = phi_t_profiles;
        % stack descriptors
descriptors_source_stacked = repmat(descriptors_source, [nb_query_points_target 1 1]);
descriptors_target_stacked = repelem(descriptors_target, nb_query_points_source, ones(1, 3), ones(1, nb_samples));

w = [w_tau; w_kappa; w_phi];


% k= k(2:end);
% 
%     % compute diff for negative shift
% diff_previous(:, :, k:(nb_samples-1)*ones(1, nb_samples-1), k) = - descriptors_target_stacked(:, :, ones(1, nb_samples-1):nb_samples*ones(1, nb_samples-1)-k);
% diff_previous(:, :, nb_samples*ones(1, nb_samples-1):(nb_samples-1)*ones(1, nb_samples-1)+k, k) = descriptors_source_stacked(:, :, ones(1, nb_samples-1):k) - descriptors_target_stacked(:, (nb_samples+1)*ones(1, nb_samples-1)-k:nb_samples*ones(1, nb_samples-1)); % source is fixed and we move target
% diff_previous(:, :, nb_samples*ones(1, nb_samples-1)+k:(2*nb_samples-1)*ones(1, nb_samples-1), k) =  descriptors_source_stacked(:, :, k+ones(1, nb_samples-1):nb_samples*ones(1, nb_samples-1));
%     %case when target fully intersects source
% diff_previous(:, :, nb_samples:2*nb_samples-1, nb_samples) = descriptors_source_stacked - descriptors_target_stacked;    
%     % compute diff for positive shift
% diff_after(:, :, k:(nb_samples-1)*ones(1, nb_samples-1), k) = - descriptors_source_stacked(:, :, ones(1, nb_samples-1):nb_samples*ones(1, nb_samples-1)-k);
% diff_after(:, :, nb_samples*ones(1, nb_samples-1):(nb_samples-1)*ones(1, nb_samples-1)+k, k) = descriptors_target_stacked(:, :, ones(1, nb_samples-1):k) - descriptors_source_stacked(:, (nb_samples+1)*ones(1, nb_samples-1)-k:nb_samples*ones(1, nb_samples-1)); % source is fixed and we move target
% diff_after(:, :, nb_samples*ones(1, nb_samples-1)+k:(2*nb_samples-1)*ones(1, nb_samples-1), k) =  descriptors_target_stacked(:, :, k+ones(1, nb_samples-1):nb_samples*ones(1, nb_samples-1));
% diff_after = flip(diff_after,4);
% diff_after = flip(diff_after, 3);



diff_previous = zeros(3, 2*nb_samples-1, nb_samples); % for target that has a negative (or null) shift compared to source 
diff_after = zeros(3, 2*nb_samples-1, nb_samples-1); % for target that has a positive shift compared to source 

        % compute diff for negative shift
for i=1:1:nb_samples-1
   diff_previous(:, i:nb_samples-1, i) = - descriptors_target_stacked(:, 1:nb_samples-i);
   diff_previous(:, nb_samples:nb_samples+i-1, i) = descriptors_source_stacked(:, 1:i) - descriptors_target_stacked(:, nb_samples-i+1:nb_samples); % source is fixed and we move target
   diff_previous(:, nb_samples+i:2*nb_samples-1, i) =  descriptors_source_stacked(:, i+1:nb_samples);
end      
        %case when target fully intersects source
diff_previous(:, nb_samples:2*nb_samples-1, nb_samples) = descriptors_source_stacked - descriptors_target_stacked;

        % compute diff for positive shift
for i=1:1:nb_samples-1
   diff_after(:, i:nb_samples-1, i) = - descriptors_source_stacked(:, 1:nb_samples-i);
   diff_after(:, nb_samples:nb_samples+i-1, i) = descriptors_target_stacked(:, 1:i) - descriptors_source_stacked(:, nb_samples-i+1:nb_samples); % source is fixed and we move target
   diff_after(:, nb_samples+i:2*nb_samples-1, i) =  descriptors_target_stacked(:, i+1:nb_samples);
end    
diff_after = flip(diff_after,3);
diff_after = flip(diff_after, 2);


        % compute dissimilarity
 diff(:,:, 1:nb_samples) = diff_previous;
 diff(:,:, nb_samples+1:2*nb_samples-1) = diff_after;
 if ~flag
        % take the whole scales to for descriptors comparison 
        %(then , we just have to compute dissimilarity min to have the shift)
        diss_whole_scales = sum(repmat(w, 1, size(diff, 2), size(diff, 3)).*(diff.^2), 1);

        % compute dissimilarity minimum
        [min_diss, index] = min(sum(diss_whole_scales, 2));
        lag = index - nb_samples;
 else
            
        % like in the paper --> search for max similarity but in a smaller
        % scale range
        max_sim = 0;
        lag = 0;
            % for negative lag
        for i=1:nb_samples
            diss = sum(repmat(w, 1, i).*diff(:, nb_samples:nb_samples+i-1, i).^2, 1);
            sim = sum(1-tanh(alpha*diss), 2)/(i);
            if sim > max_sim
                max_sim = sim;
                lag = (i-nb_samples);
            end
        end
            % for positive lag
        for i=1:nb_samples-1
            diss = sum(repmat(w, 1, nb_samples-i).*diff(:, 1+i:nb_samples, nb_samples+i).^2, 1);
            sim = sum(1-tanh(alpha*diss), 2)/((nb_samples-i));
            if sim > max_sim
                max_sim = sim;
                lag = i;
            end
        end
end


end




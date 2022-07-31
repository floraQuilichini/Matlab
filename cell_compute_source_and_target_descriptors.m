function [descriptors_source,descriptors_target] = cell_compute_source_and_target_descriptors(min_scale, max_scale, nb_samples, source_queries, target_queries, source_pts, target_pts, source_normals, target_normals)


% first, we need to compute our GLS descriptor in a logarithmic base
    % compute log base
m_base = (max_scale/min_scale).^(1/(nb_samples-1));

    % initialize scales
k = (0:1:nb_samples-1);
scales = m_base.^(k)*min_scale;

    % compute profiles
        % on all target points
[tau_t_profiles, ~, kappa_t_profiles, phi_t_profiles] = cell_compute_GLS_descriptor(target_queries, scales, target_pts, target_normals, 'Multiscale');        
        % on selected source points       
[tau_s_profiles, ~, kappa_s_profiles, phi_s_profiles] = cell_compute_GLS_descriptor(source_queries, scales, source_pts, source_normals, 'Multiscale');

        % build descriptors
if size(tau_s_profiles, 1) == 1
    descriptors_source = cat(2, tau_s_profiles, kappa_s_profiles, phi_s_profiles);
else
    descriptors_source = cat(3, squeeze(tau_s_profiles), squeeze(kappa_s_profiles), squeeze(phi_s_profiles));
    descriptors_source = permute(descriptors_source,[1 3 2]);
end

if size(tau_t_profiles, 1) == 1
    descriptors_target = cat(2, tau_t_profiles, kappa_t_profiles, phi_t_profiles);
else
    descriptors_target = cat(3, squeeze(tau_t_profiles), squeeze(kappa_t_profiles), squeeze(phi_t_profiles));
    descriptors_target = permute(descriptors_target,[1 3 2]);
end
    


end


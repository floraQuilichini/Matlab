function [lag, m_base, max_sim] = shift_estimation(min_scale, max_scale, nb_samples, p1, p2, Pts_1, Pts_2, Normals_1, Normals_2, alpha, varargin)
%This function is used to estimate the shift between profiles of two GLS
%descriptor computed in p1 and p2. Having the shift will enable us, in a 
%further step, to compute the relative scale between Pts_1 and Pts_2
% (we assume that p1 belongs to source and p2 to target)
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

% first, we need to compute our GLS descriptor in a logarithmic base
    % compute log base
m_base = (max_scale/min_scale).^(1/(nb_samples-1));
display(m_base)
min_log_scale = log(min_scale)/log(m_base);
max_log_scale = log(max_scale)/log(m_base);
display(min_log_scale)
display(max_log_scale)

    % initialize profiles
tau1_profile = zeros(1, nb_samples);
kappa1_profile = zeros(1, nb_samples);
phi1_profile = zeros(1, nb_samples);
tau2_profile = zeros(1, nb_samples);
kappa2_profile = zeros(1, nb_samples);
phi2_profile = zeros(1, nb_samples);

for k=0:nb_samples-1  % can be speed up with parallelization
   % compute profiles
        % compute scale
   %scale = m_base.^(min_log_scale+k); % equivalent à la ligne du dessous
   scale = m_base.^(k)*min_scale;
        % compute descriptors
   [tau1, ~, kappa1, phi1] = compute_GLS_descriptor(p1, scale, Pts_1, Normals_1);
   [tau2, ~, kappa2, phi2] = compute_GLS_descriptor(p2, scale, Pts_2, Normals_2);
   tau1_profile(k+1) = tau1;
   kappa1_profile(k+1) = kappa1;
   phi1_profile(k+1) = phi1;
   tau2_profile(k+1) = tau2;
   kappa2_profile(k+1) = kappa2;
   phi2_profile(k+1) = phi2;
end


% find max argument of similarity function  (obtained when cross-correlation is maximal)

%% we dont need this --> cross correlation must be computed on dissimilarity function (and not on the different [tau, kappa, phi] profiles 

% max_cross_corr = 0;
% lag = 0;
% 
%     % compute cross-correlation for tau, kappa and phi profiles
% [tau_cross_corr,tau_lags] = xcorr(tau1,tau2); % measure tau shift source->target (target profile moves and source is fixed)
% [kappa_cross_corr,kappa_lags] = xcorr(kappa1,kappa2);
% [phi_cross_corr,phi_lags] = xcorr(phi1,phi2);

%%

    % compute dissimilarity
descriptors_vec1 = [tau1_profile; kappa1_profile; phi1_profile];
descriptors_vec2 = [tau2_profile; kappa2_profile; phi2_profile];
w = [w_tau; w_kappa; w_phi];


diff_previous = zeros(3, 2*nb_samples-1, nb_samples); % for target that has a negative (or null) shift compared to source 
diff_after = zeros(3, 2*nb_samples-1, nb_samples-1); % for target that has a positive shift compared to source 

        % compute diff for negative shift
for i=1:1:nb_samples-1
   diff_previous(:, i:nb_samples-1, i) = - descriptors_vec2(:, 1:end-i);
   diff_previous(:, nb_samples:nb_samples+i-1, i) = descriptors_vec1(:, 1:i) - descriptors_vec2(:, end-i+1:end); % source is fixed and we move target
   diff_previous(:, nb_samples+i:2*nb_samples-1, i) =  descriptors_vec1(:, i+1:end);
end      
        %case when target fully intersects source
diff_previous(:, nb_samples:2*nb_samples-1, nb_samples) = descriptors_vec1 - descriptors_vec2;

        % compute diff for positive shift
for i=1:1:nb_samples-1
   diff_after(:, i:nb_samples-1, i) = - descriptors_vec1(:, 1:end-i);
   diff_after(:, nb_samples:nb_samples+i-1, i) = descriptors_vec2(:, 1:i) - descriptors_vec1(:, end-i+1:end); % source is fixed and we move target
   diff_after(:, nb_samples+i:2*nb_samples-1, i) =  descriptors_vec2(:, i+1:end);
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


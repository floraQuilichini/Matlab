function final_lag = cell_lag_estimation(descriptors_source, descriptors_target, nb_samples, w, alpha)

% descriptors are n by 3 by k matrices, where :
% - n corresponds to the number of points (we take the same n number of 
% points in source and target to compute the lag) 
% - 3 is for the number of GLS parameters( tau, kappa, phi)
% - k is the scale values (same k for scriptors_source and
% descriptors_target)
% - w is a 1 by 3 vector
% - alpha is a scalar


nb_points = size(descriptors_source, 1);
        % stack descriptors (in order to compare each source point with
        % each target point)
descriptors_source_stacked = repmat(descriptors_source, [nb_points 1 1]);
descriptors_target_stacked = repelem(descriptors_target, nb_points, ones(1, 3), ones(1, nb_samples));

        % initialize diff
diff_previous = zeros(nb_points.^2, 3, 2*nb_samples-1, nb_samples); % for target that has a negative (or null) shift compared to source 
diff_after = zeros(nb_points.^2, 3, 2*nb_samples-1, nb_samples-1); % for target that has a positive shift compared to source 

        % compute diff for negative shift
for i=1:1:nb_samples-1
   diff_previous(:, :, i:nb_samples-1, i) = - descriptors_target_stacked(:, :, 1:nb_samples-i);
   diff_previous(:, :, nb_samples:nb_samples+i-1, i) = descriptors_source_stacked(:, :, 1:i) - descriptors_target_stacked(:, :, nb_samples-i+1:nb_samples); % source is fixed and we move target
   diff_previous(:, :, nb_samples+i:2*nb_samples-1, i) =  descriptors_source_stacked(:, :, i+1:nb_samples);
end      
        %case when target fully intersects source
diff_previous(:, :, nb_samples:2*nb_samples-1, nb_samples) = descriptors_source_stacked - descriptors_target_stacked;

        % compute diff for positive shift
for i=1:1:nb_samples-1
   diff_after(:, :, i:nb_samples-1, i) = - descriptors_source_stacked(:, :, 1:nb_samples-i);
   diff_after(:, :, nb_samples:nb_samples+i-1, i) = descriptors_target_stacked(:, :, 1:i) - descriptors_source_stacked(:, :, nb_samples-i+1:nb_samples); % source is fixed and we move target
   diff_after(:, :, nb_samples+i:2*nb_samples-1, i) =  descriptors_target_stacked(:, :, i+1:nb_samples);
end    
diff_after = flip(diff_after,4);
diff_after = flip(diff_after, 3);


        % compute dissimilarity
 diff(:, :,:, 1:nb_samples) = diff_previous;
 diff(:, :,:, nb_samples+1:2*nb_samples-1) = diff_after;
 
            
    % like in the paper --> search for max similarity but in a smaller
    % scale range
    max_sim = zeros(nb_points*nb_points, 1);
    lags = zeros(nb_points*nb_points, 1);
    
        % for negative lag
    for i=1:nb_samples
        diss = sum(repmat(w', nb_points.^2, 1, i).*diff(:, :, nb_samples:nb_samples+i-1, i).^2, 2);
        sim = sum(1-tanh(alpha*diss), 3)/(i);
        if sum(sim > max_sim)
            lags(sim > max_sim) = (i-nb_samples);
            max_sim(sim > max_sim) = sim(sim > max_sim);
        end
    end
        % for positive lag
    for i=1:nb_samples-1
        diss = sum(repmat(w', nb_points.^2, 1, nb_samples-i).*diff(:, :, 1+i:nb_samples, nb_samples+i).^2, 2);
        sim = sum(1-tanh(alpha*diss), 3)/((nb_samples-i));
        if sum(sim > max_sim)
            lags(sim > max_sim) = i;
            max_sim(sim > max_sim) = sim(sim > max_sim);
        end
    end

[max_sim, index] = max(reshape(max_sim, nb_points, nb_points), [], 2);
index = (index - ones(nb_points, 1))*nb_points + (1:1:nb_points)';

final_lags = lags(index);
% final_lag = median(final_lags);
final_lag = mean(final_lags);


end


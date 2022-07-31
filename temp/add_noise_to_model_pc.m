function [pc_coord_noise, mean_vector, sd_vector] = add_noise_to_model_pc(pc_model, type_of_noise, nb_noise_matrix, varargin)
% Function that computes a specified number of matrices of a noise type
% (choose between 'gaussian' and 'white' and add them to the point cloud. 
% The user can specified the noise parameters (optional - mean and standard
% deviation error or noise level). The noise matrices are then applied to
% the point cloud coordinates


%% sanity checks

numvararg = length(varargin);
mean_vector = [];
sd_vector= [];

if numvararg > 2
    error('there are at most 2 optional parameters (mean and standard deviation)');
end

if ~strcmp(type_of_noise, 'gaussian') && ~strcmp(type_of_noise, 'white')
    error('you must choose noise type between "gaussian" and "white"');
end

if numvararg == 2
    [mean_vector, sd_vector] = varargin{:};
    if size(mean_vector) ~= size(sd_vector)
        error('mean and deviation vectors must have the same length');
    end
elseif numvararg == 1
    noise_level = varargin{1:1};
else
    noise_level = 0.5;
end
 

%% add gaussian noise to point cloud

if size(mean_vector) ~= 0
    pc_coord_noise = add_noise_to_pc(pc_model, type_of_noise, nb_noise_matrix, mean_vector, sd_vector);
else
    [pc_coord_noise, mean_vector, sd_vector] = add_noise_to_pc(pc_model, type_of_noise, nb_noise_matrix, noise_level);
end
    


end


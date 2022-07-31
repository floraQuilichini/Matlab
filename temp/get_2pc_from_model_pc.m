function [pc_up_coord_noise,pc_down_coord_noise, mean_vector, sd_vector] = get_2pc_from_model_pc(rot, trans, model_pc, cutting_plane, ratio, type_of_noise,nb_noise_matrix, varargin)
% function that takes an input a transformation (rotation matrix and translation vector)
% to apply to a point cloud derived from the point cloud model (model_pc).
% Two derived points clouds are obtained by cutting the model point cloud along
% a plane direction ('XY', 'YZ', 'ZX'), accordingly to some plane position
% ratio (between [0, 1]). Then some noise ('gaussian' or 'white') matrices 
% (whose number is given by number_noise_array) are separatedly added to both
% of the resulting point clouds. The user can specify (optional) the mean
% and standard deviation of the noise, or the level of noise he want to add 
% in the data (in case he didn't enter the previous values). 



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

%% cut the scan point cloud along a plane
[pc_up, pc_down] = cut_pc_by_plane(model_pc, cutting_plane, ratio); 


%% add gaussian noise to point cloud

if size(mean_vector) ~= 0
    pc_up_coord_noise = add_noise_to_pc(pc_up, type_of_noise, nb_noise_matrix, mean_vector, sd_vector);
    pc_down_coord_noise = add_noise_to_pc(pc_down, type_of_noise, nb_noise_matrix, mean_vector, sd_vector);
else
    [pc_up_coord_noise, mean_vector, sd_vector] = add_noise_to_pc(pc_up, type_of_noise, nb_noise_matrix, noise_level);
    pc_down_coord_noise = add_noise_to_pc(pc_down, type_of_noise, nb_noise_matrix, noise_level);
end


%% apply transformation
T = zeros(4, 4);
T(1:3, 1:3) = rot;
T(1:3, 4) = transpose(trans);
T(4, 4) = 1; 

for i=1:size(pc_up_coord_noise, 3)  % à optimiser (see post : https://fr.mathworks.com/matlabcentral/answers/97028-how-can-i-perform-multi-dimensional-matrix-multiplication-in-matlab , sol : http://www.mit.edu/~pwb/matlab/)
    pc_up_coord_noise(:,:,i) = applyTtoPc(pc_up_coord_noise(:,:,i), T);
end

for i=1:size(pc_down_coord_noise, 3)
    pc_down_coord_noise(:,:,i) = applyTtoPc(pc_down_coord_noise(:,:,i), T);
end


end


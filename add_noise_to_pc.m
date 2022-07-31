function [pcCoord_noise, mean_vector, sd_vector] = add_noise_to_pc(pc, type_of_noise, number_noise_array, varargin)
%UNTITLED3 Summary of this function goes here
%   This function add noise to a point cloud 
%   The  three input parameters are, in that order : 
%   - the point cloud 
%   - the type of noise (to choose between 'gaussian' or 'white') 
%   - the number of noise map we want to compute
%   the two other ones are optional and refers to :
%   - the mean value vector of the noise distributions 
%   - the standard deviation vector (in case of a gaussian noise)
% if the optional parameters are not entered, then te algorithm will find a
% level of noise that is coherent with the data
% The output of the algorithm is the point cloud coordinates matrices with
% added noise, and the noise vectors of mean and standard deviation values

%% sanity check
numvararg = length(varargin);
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

%% add noise

pcCoord = pc.Location;
if number_noise_array ~= 0
    [l, c] = size(pcCoord); % get number of points in pc
    noise = zeros(l, c, number_noise_array);

    if strcmp(type_of_noise, 'gaussian')
        if numvararg == 2
            % use the mean and standard deviation values entered by the user
            for i = 1:size(mean_vector)
                noise(:,:,i) = single(sd_vector(i)*randn(l, c) + mean_vector(i));
            end
        else
            % use the value found by the algorithm
            [noise, mean_vector, sd_vector] = compute_data_driven_noise_parameters(pc, 'gaussian', noise_level, number_noise_array);
        end
    else
        if numvararg == 2
            % use the mean and standard deviation values entered by the user
            for i = 1:size(mean_vector)
                noise(:,:,i) = single(sd_vector(i)*rand(l, c) + mean_vector(i) - 0.5);
            end
        else
            % use the value found by the algorithm
            [noise, mean_vector, sd_vector] = compute_data_driven_noise_parameters(pc, 'white', noise_level, number_noise_array);
        end
    end

    pcCoord_rep = zeros(l, c, number_noise_array);
    for i = 1:number_noise_array
        pcCoord_rep(:,:,i) = single(pcCoord); % cast point cloud coordinates to float, otherwise pcl load function for point cloud won't be able to read the generated pcd file (SIZE 4, 4, 4)
    end
    pcCoord_noise = pcCoord_rep + noise;
else
    pcCoord_noise = pcCoord;
    mean_vector = 0;
    sd_vector = 0;
end

end


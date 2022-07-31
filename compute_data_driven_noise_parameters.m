function [noise_matrix, mean_vec, sd_vec] = compute_data_driven_noise_parameters(pc,noise_type, noise_level, number_noise_array)
%   Function that computes noise parameters (mean and standard deviation) 
%   according to the data. It takes as input parameters :
%   - the point cloud
%   - the type of noise we want to add ('gaussian' or 'white')
%   - the level of noise we want to add (to differanciate scan point cloud
%   with low noise from hololens point cloud with higher noise)
%   - the number of arrays of noise wanted
%  it outputs the generated matrix of noise, with the mean values of the
%  noise (here 0) and the mean standard deviation values

pcCoord = pc.Location;
% determine the number of testing points to compute noise parameters
[nb_points, nb_coord] = size(pcCoord);
if nb_points <= 10
    nb_test_points = 1;
elseif nb_points <= 100
    nb_test_points = 4;
elseif nb_points <= 10000
    nb_test_points = 10;
else
    nb_test_points = 30;
end

% pick randomly nb testing points in the pcCoord array
point_index_array = int64(randi(nb_points, 1, nb_test_points));

% find the 6 nearest neighbours of each test points
global_dist = 0;
for i=1:nb_test_points
    point_index = point_index_array(1, i);
    [indices,dists] = findNearestNeighbors(pc,pcCoord(point_index, :),6);
    global_dist = global_dist + mean(dists);
end
% and compute the global neighbouring distance for this set of points
global_dist = global_dist/nb_test_points;
noise_matrix = zeros(nb_points, nb_coord, number_noise_array);


mean_vec = zeros(1, number_noise_array);
sd_vec = zeros(1, number_noise_array);
% compute noise matrices
if strcmp(noise_type, 'gaussian')
    for i=1:number_noise_array
        noise_matrix(:,:,i) = noise_level*(i/number_noise_array)*global_dist*randn(nb_points, nb_coord);
        sd_vec(i) = noise_level*(i/number_noise_array);
    end
else
    for i=1:number_noise_array
        noise_matrix(:,:,i) = noise_level*(i/number_noise_array)*global_dist*rand(nb_points, nb_coord) - 0.5; 
        sd_vec(i) = noise_level*(i/number_noise_array);
    end
end

end


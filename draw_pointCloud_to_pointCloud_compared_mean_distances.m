function figure_filename = draw_pointCloud_to_pointCloud_compared_mean_distances(path, figure_name, varargin)
% function that draw point cloud to point cloud distances function of the
% level of sampling. The input parameter is a file that contains, in
% others, the level of subsampling for each experiment, and the associated
% distance. 

%% check variables are correct
if nargin < 4
    error('you must enter at least the path where you want to save the figure, the name of the saved figure, the filename where to extract data, and the curve name');
elseif mod(nargin - 2, 2)
    error('for each filename from wich you want to extract data, you have to give at next parameter a name for the curve to plot (which will figure in the plot legend)');
end

display(nargin)

%% get variables
nb_files = ((nargin-2)/2);
filenames = strings(1, nb_files);
curve_names = strings(1, nb_files);

% get filenames
for i = 1:2:(nargin-2)
    filenames(1, ceil(i/2)) = varargin{i}; 
end


% get curve names
for i = 2:2:(nargin-2)
    curve_names(1, ceil(i/2)) = varargin{i};       
end


%% process filenames data
means_file = cell(nb_files, 1);
std_file = cell(nb_files, 1);
coeffs_file = cell(nb_files, 1);

for i = 1:1:nb_files
    
    data = importdata(filenames(1, i), '\n');
    nb_lines = size(data, 1);
    last_line = data{nb_lines, 1};
    nb_tests = uint8(str2num(char(extractBetween(last_line, "test ", " ending"))));
    nb_downsampling_coeffs = (nb_lines - 1)/(2*nb_tests);


    % get means and stds values
    meanDist_array = zeros(nb_downsampling_coeffs, nb_tests);
    meanStd_array = zeros(nb_downsampling_coeffs, nb_tests);


    for k = 0:1:nb_tests-1
        j = 0;
        for ind = k*(2*nb_downsampling_coeffs+1)+2:2:k*(2*nb_downsampling_coeffs+1)+2*nb_downsampling_coeffs
            j = j + 1;
            l = data{ind, 1};
            mean_dist = char(extractBetween(l, 'Mean distance = ', ' / std deviation'));
            std_dev = extractAfter(l, 'std deviation = ');
            meanDist_array(j, k+1) = str2double(mean_dist);
            meanStd_array(j, k+1) = str2double(std_dev);
        end
    end

    global_means = mean(meanDist_array, 2)';
    global_stds = mean(meanStd_array, 2)';
%     means_file(i, 1) = {global_means};
%     std_file(i, 1) = {global_stds};
    if size(global_means, 2) > 5
            means_file(i, 1) = {global_means(1:end-2)};
            std_file(i, 1) = {global_stds(1:end-2)};
    else
        means_file(i, 1) = {global_means(1:end-1)};
        std_file(i, 1) = {global_stds(1:end-1)};
    end
    
    % get downsampling coeff
    data_downsampling = data(1:2:2*nb_downsampling_coeffs, 1);
    coeffs = zeros(1, nb_downsampling_coeffs);
    for k = 1:1:size(data_downsampling, 1)
        l = data_downsampling{k, 1};
        fraction = char(extractBetween(l, 'downsampling : ', ' ; objet target'));
        coeffs(k) = str2double(fraction);
    end
%     coeffs_file(i, 1) = {coeffs};
    if size(global_means, 2) > 5
        coeffs_file(i, 1) = {coeffs(1:end-2)};
    else
        coeffs_file(i, 1) = {coeffs(1:end-1)};
    end

end


%% display curves

% uncomment if you want to set the color by yourself
    % compute colors for curves    
colors = zeros(nb_files, 3);
if nb_files > 1
    
    nb_different_values = ceil((nb_files+1)^(1/3));

    step = 1.0/(nb_different_values - 1);

    block_size = nb_different_values^(2);

    vG = zeros(block_size, 1);
    vR = zeros(block_size, 1);
    vB = zeros(nb_different_values^(3), 1);
    for i = 0:1:nb_different_values - 1
        vB(1+i*block_size:1:(i+1)*block_size, 1) = i*step*ones(block_size, 1);
        vG(1+i*(nb_different_values):1:(i+1)*nb_different_values, 1) = i*step*ones(nb_different_values, 1);
        vR(1+i:nb_different_values:end, 1) = i*step;
    end

    for i = 0:1:nb_different_values-2
        colors(1+i*block_size:1:(i+1)*block_size, 3) = vB(1+i*block_size:1:(i+1)*block_size, 1);
        colors(1+i*block_size:1:(i+1)*block_size, 2) = vG;
        colors(1+i*block_size:1:(i+1)*block_size, 1) = vR;
    end

    nb_remaining_colors = nb_files - block_size*(nb_different_values - 1);
    if (nb_remaining_colors > 0)
        remaining_colors = [vR(1:1:nb_remaining_colors, 1), vG(1:1:nb_remaining_colors, 1), vB(1+block_size*(nb_different_values-1):1:block_size*(nb_different_values-1)+nb_remaining_colors)];
        colors(1+block_size*(nb_different_values-1):end, :) = remaining_colors;
    end

end    
%%

figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
    % plot all points of the curves
subplot(2,1,1)
set(gca, 'XDir','reverse')
title('point cloud to point cloud mean distance function of downsampling')
grid
for i = 1:1:nb_files
    hold on
    plot(coeffs_file{i, 1}, means_file{i, 1}, 'LineStyle', '-', 'Color', colors(i, :), 'Marker', '*'); 
%     plot(coeffs_file{i, 1}, means_file{i, 1}, 'LineStyle', '-', 'Marker', '*'); 
end
hold off
legend(curve_names, 'Location', 'northeastoutside', 'Orientation', 'vertical')


subplot(2,1,2)
set(gca, 'XDir','reverse')
title('point cloud to point cloud standard deviation function of downsampling')
grid
for i = 1:1:nb_files
    hold on
    plot(coeffs_file{i, 1}, std_file{i, 1}, 'LineStyle', '-', 'Color', colors(i, :), 'Marker', '*'); 
%     plot(coeffs_file{i, 1}, std_file{i, 1}, 'LineStyle', '-', 'Marker', '*'); 
end
hold off
legend(curve_names, 'Location', 'northeastoutside', 'Orientation', 'vertical') 


% save figure
    %figure_name = 'm0-s0.5-m0-s1_cc_curve.png';
figure_filename = fullfile(path, figure_name);
saveas(figure1, figure_filename); 


end





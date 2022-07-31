function figure_filename = draw_pointCloud_to_pointCloud_distance_v2(path, varargin)
% function that draw point cloud to point cloud distances function of the
% level of sampling. The input parameter is a file that contains, in
% others, the level of subsampling for each experiment, and the associated
% distance. 

%% check variables are correct
if nargin < 3
    error('you must enter at least the path where you want to save the figure, the filename where to extract data, and the curve name');
elseif mod(nargin - 1, 2)
    error('for each filename from wich you want to extract data, you have to give at next parameter a name for the curve to plot (which will figure in the plot legend)');
end

display(nargin)

%% get variables
nb_files = ((nargin-1)/2);
filenames = strings(1, nb_files);
curve_names = strings(1, nb_files);

% get filenames
for i = 1:2:(nargin-1)
    filenames(1, ceil(i/2)) = varargin{i}; 
end


% get curve names
for i = 2:2:(nargin-1)
    curve_names(1, ceil(i/2)) = varargin{i};       
end


%% process filenames data
means_file = cell(nb_files, 1);
std_file = cell(nb_files, 1);
coeffs_file = cell(nb_files, 1);

for i = 1:1:nb_files
    data = importdata(filenames(1, i));

    if (size(data, 1) > 2)  % FGR registration    
        data_stats = data(3:3:end, 1);
        means = zeros(1, size(data_stats, 1));
        std_devs = zeros(1, size(data_stats, 1));
    else   % ICP registration
        data_stats = data(2, 1);
        means = zeros(1, 1);
        std_devs = zeros(1, 1);
    end
    
    % get mean and standard deviation
    for j = 1:1:size(data_stats, 1)
        l = data_stats{j, 1};
        mean_dist = char(extractBetween(l, 'Mean distance = ', ' / std deviation'));
        std_dev = extractAfter(l, 'std deviation = ');
        means(j) = str2double(mean_dist);
        std_devs(j) = str2double(std_dev);
    end
    means_file(i, 1) = {means};
    std_file(i, 1) = {std_devs};

    % get downsampling coeff
    if (size(data, 1) > 2)  % FGR registration
        data_downsampling = data(1:3:end, 1);
        coeffs = zeros(1, size(data_downsampling, 1));
        for j = 1:1:size(data_stats, 1)
            l = data_downsampling{j, 1};
            fraction = char(extractBetween(l, 'downsampling : ', ' ; objet target'));
            coeffs(j) = str2double(fraction);
        end
        coeffs_file(i, 1) = {coeffs};
    else   % ICP
        coeffs_file(i, 1) = {1.0};
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
        remaining_colors = [vR(1:1:nb_remaining_colors, 1); vG(1:1:nb_remaining_colors, 1); vB(1+block_size*(nb_different_values-1):1:block_size*(nb_different_values-1)+nb_remaining_colors)];
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
figure_name = 'm0-s0.5-m0-s1_cc_curve.png';
figure_filename = fullfile(path, figure_name);
saveas(figure1, figure_filename); 


end



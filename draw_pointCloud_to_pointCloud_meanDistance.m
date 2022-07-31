function figure_filename = draw_pointCloud_to_pointCloud_meanDistance(filename_cc_results, varargin)
% function that draw point cloud to point cloud distances function of the
% level of sampling. The input parameter is a file that contains, in
% others, the level of subsampling for each experiment, and the associated
% distance. 

numvararg = length(varargin);
addICPCurve = false;
if numvararg > 1
    error('there is at last one optional parameter (this parameter is the ICP registration file');
elseif numvararg == 1
    if ischar(varargin{1})
        addICPCurve = true;
    else
        error('the optional parameter must be the ICP registration file');
    end
end

%% process main filename data
data = importdata(filename_cc_results, '\n');
nb_lines = size(data, 1);
last_line = data{nb_lines, 1};
nb_tests = uint8(str2num(char(extractBetween(last_line, "test ", " ending"))));
nb_downsampling_coeffs = (nb_lines - 1)/(2*nb_tests);


% get means and stds values
meanDist_array = zeros(nb_downsampling_coeffs, nb_tests);
meanStd_array = zeros(nb_downsampling_coeffs, nb_tests);


for k = 0:1:nb_tests-1
    j = 0;
    for i = k*(2*nb_downsampling_coeffs+1)+2:2:k*(2*nb_downsampling_coeffs+1)+2*nb_downsampling_coeffs
        j = j + 1;
        l = data{i, 1};
        mean_dist = char(extractBetween(l, 'Mean distance = ', ' / std deviation'));
        std_dev = extractAfter(l, 'std deviation = ');
        meanDist_array(j, k+1) = str2double(mean_dist);
        meanStd_array(j, k+1) = str2double(std_dev);
    end
end

global_means = mean(meanDist_array, 2)';
global_stds = mean(meanStd_array, 2)';


% get downsampling coeff
data_downsampling = data(1:2:2*nb_downsampling_coeffs, 1);
coeffs = zeros(1, nb_downsampling_coeffs);
for i = 1:1:size(data_downsampling, 1)
    l = data_downsampling{i, 1};
    fraction = char(extractBetween(l, 'downsampling : ', ' ; objet target'));
    coeffs(i) = str2double(fraction);
end


%% process optional data filename
if addICPCurve
    ICP_output_file = varargin{1};
    dataICP = importdata(ICP_output_file, '\n');
    nb_tests_icp  = size(dataICP, 1)/2;
    meanDist_ICP_array = zeros(1, nb_tests_icp);
    meanStd_ICP_array = zeros(1, nb_tests_icp);
    for i = 2:2:2*nb_tests_icp
        l = dataICP{i, 1};
        mean_dist_ICP = str2double(char(extractBetween(l, 'Mean distance = ', ' / std deviation')));
        std_dev_ICP = str2double(extractAfter(l, 'std deviation = '));
        meanDist_ICP_array(i/2)  = mean_dist_ICP;
        meanStd_ICP_array(i/2)  = std_dev_ICP; 
    end
end

%% display curves

figure1 = figure('units','normalized','outerposition',[0 0 1 1]);

    % plot all points of the curves
subplot(2,1,1)
plot(coeffs,global_means, 'b')
set(gca, 'XDir','reverse')
title('point cloud to point cloud mean distance function of downsampling')
grid
if addICPCurve
    hold on 
    plot(coeffs, repmat(mean(meanDist_ICP_array), 1, size(coeffs, 2)), 'g')
    hold off
    legend('FGR','ICP')
else
    legend('FGR')
end
subplot(2,1,2)
plot(coeffs,global_stds, 'b')
set(gca, 'XDir','reverse')
title('point cloud to point cloud standard deviation function of downsampling')
grid
if addICPCurve
    hold on 
    plot(coeffs, repmat(mean(meanStd_ICP_array), 1, size(coeffs, 2)), 'g')
    hold off
    legend('FGR','ICP')
else
    legend('FGR')
end


% save figure
path = fileparts(filename_cc_results);
figure_name = 'cc_curve.png';
saveas(figure1, fullfile(path, figure_name)); 
figure_filename = fullfile(path, figure_name);

end



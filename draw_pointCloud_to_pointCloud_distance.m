function figure_filename = draw_pointCloud_to_pointCloud_distance(filename_cc_results, varargin)
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
data = importdata(filename_cc_results);

% get mean and standard deviation
data_stats = data(2:2:end, 1);
means = zeros(1, size(data_stats, 1));
std_devs = zeros(1, size(data_stats, 1));
for i = 1:1:size(data_stats, 1)
    l = data_stats{i, 1};
    mean_dist = char(extractBetween(l, 'Mean distance = ', ' / std deviation'));
    std_dev = extractAfter(l, 'std deviation = ');
    means(i) = str2double(mean_dist);
    std_devs(i) = str2double(std_dev);
end

% get downsampling coeff
data_downsampling = data(1:2:end, 1);
coeffs = zeros(1, size(data_downsampling, 1));
for i = 1:1:size(data_stats, 1)
    l = data_downsampling{i, 1};
    fraction = char(extractBetween(l, 'downsampling : ', ' ; objet target'));
    coeffs(i) = str2double(fraction);
end


%% process optional data filename
if addICPCurve
    ICP_output_file = varargin{1};
    dataICP = importdata(ICP_output_file, '\n');
    l = dataICP{2, 1};
    mean_dist_ICP = str2double(char(extractBetween(l, 'Mean distance = ', ' / std deviation')));
    std_dev_ICP = str2double(extractAfter(l, 'std deviation = '));    
end

%% display curves

figure1 = figure('units','normalized','outerposition',[0 0 1 1]);

    % plot all points of the curves
subplot(2,1,1)
plot(coeffs,means, 'b')
set(gca, 'XDir','reverse')
title('point cloud to point cloud mean distance function of downsampling')
grid
if addICPCurve
    hold on 
    plot(coeffs, repmat(mean_dist_ICP, 1, size(data_downsampling, 1)), 'g')
    hold off
    legend('FGR','ICP')
else
    legend('FGR')
end
subplot(2,1,2)
plot(coeffs,std_devs, 'b')
set(gca, 'XDir','reverse')
title('point cloud to point cloud standard deviation function of downsampling')
grid
if addICPCurve
    hold on 
    plot(coeffs, repmat(std_dev_ICP, 1, size(data_downsampling, 1)), 'g')
    hold off
    legend('FGR','ICP')
else
    legend('FGR')
end
%     % plot partial curves
% subplot(2,2,2)
% plot(coeffs(1:1:end-1),means(1:1:end-1), 'b')
% set(gca, 'XDir','reverse')
% title('zoom on mean distance')
% grid
% if addICPCurve
%     hold on 
%     plot(coeffs(1:1:end-1), repmat(std_dev_ICP, 1, size(data_downsampling, 1) - 1), 'g')
%     hold off
%     legend('FGR','ICP')
% else
%     legend('FGR')
% end
% subplot(2,2,4)
% plot(coeffs(1:1:end-1),std_devs(1:1:end-1), 'b')
% set(gca, 'XDir','reverse')
% title('zoom on standard deviation')
% grid
% if addICPCurve
%     hold on 
%     plot(coeffs(1:1:end-1), repmat(std_dev_ICP, 1, size(data_downsampling, 1) - 1), 'g')
%     hold off
%     legend('FGR','ICP')
% else
%     legend('FGR')
% end


% save figure
path = fileparts(filename_cc_results);
figure_name = 'cc_curve.png';
saveas(figure1, fullfile(path, figure_name)); 
figure_filename = fullfile(path, figure_name);

end


function [FPFHArray, nb_fpfh_points, nb_hist_bins] = readFPFHHistogram(fpfh_file)
% function that read a text file containing the histogram values for each
% point processed by FPFH algorithm. It save the histograms and returns an array 
% of tuple (point-hist). FPFH text file is contains values stored in
% column. 

[dir, name, ext] = fileparts(fpfh_file);
if ~strcmp(ext, ".txt")
    fprintf('error, the file extension must be ".txt"');
else
    file_data = importdata(fpfh_file, '\n'); % import file
    nb_fpfh_points = file_data(1); % get number of points
    nb_hist_bins = file_data(2); % get number of bins
    % FPFH array initialization
    x = 1:nb_hist_bins;
    fpfh.p = zeros(3, 1);
    fpfh.hx = x;
    fpfh.hy = zeros(1, nb_hist_bins);
    FPFHArray = repmat(fpfh,1,nb_fpfh_points);
    % fill FPFH array
        % get point array
    P = [file_data(3:3+nb_hist_bins:end), file_data(4:3+nb_hist_bins:end), file_data(5:3+nb_hist_bins:end)];
        % get histogram values array
    u = 6:1:6+nb_hist_bins-1;
    v= 0:3+nb_hist_bins:(3+nb_hist_bins)*(size(P,1)-1);
    ur = repmat(u, 1, size(P,1));
    vr = repelem(v, nb_hist_bins);
    ind_H = ur+vr;
    H = reshape(file_data(ind_H),nb_hist_bins, []);
        % fill FPFH array with P and H
    Cp = num2cell(transpose(P), 1);
    Ch_y = num2cell(transpose(H), 2);
    [FPFHArray(:).p] = Cp{:};
    [FPFHArray(:).hy] = Ch_y{:};
       
%    % save histogram
%       % define loop parameters
%     step = 3+nb_hist_bins;
%     init = 3;
%     index = 1; 
%     mkdir(fullfile(dir, strcat(name, '_point_hist')));
%     for i=init:step:init+(nb_fpfh_points-1)*step
%         histogramme = bar(x, hist_val);
%         filename = strcat('histogram_p_', num2str(point(1)), '_', num2str(point(2)), '_', num2str(point(3)), '.fig');
%         %saveas(f, fullfile(dir, strcat(name, '_point_hist'), filename));
%         savefig(fullfile(dir, strcat(name, '_point_hist'), filename));
%         pause;
% 
% %         point = file_data(i:i+2, 1);
% %         hist_val = file_data(i+3:i+3+(nb_hist_bins-1), 1);
% %         % save point-hist struct
% %         fpfh(1).p = point;
% %         fpfh(1).h = [x; transpose(hist_val)]; 
% %         HistArray(index) = fpfh;
% %         index = index + 1;
%     end
end



end


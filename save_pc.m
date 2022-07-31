function [full_directory, pc_names] = save_pc(pc_name, prefix, pcCoords_array, mean_vector, sd_vector, theta, rot_axis, trans, parent_directory, varargin)
%function that save arrays of point cloud coordinates into point clouds. 
% prefix is "_up_" or "_down_"
% return the full directory where the files are saved

numvararg = length(varargin);
if numvararg > 2
    error('too many optional parameters');
elseif numvararg == 2
    if isnumeric(varargin{1})
        cut_ratio = num2str(varargin{1});
        if ischar(varargin{2})
            cutting_plane = varargin{2};
        else
            error('optional parameter must be of float/double type and char type');
        end
    elseif ischar(varargin{1})
        cutting_plane = varargin{1};
        if isnumeric(varargin{2})
            cut_ratio = num2str(varargin{2});
        else
           error('optional parameter must be of float/double type and char type'); 
        end
    else
        error('optional parameter must be of float/double type and char type');
    end
    
elseif numvararg == 1
    error('you have to enter both cutting ratio and cutting plane optional parameters, or none of them');
end

directory = strcat("theta", num2str(theta), "_t", num2str(trans(1)), "_", num2str(trans(2)), "_", num2str(trans(3)), rot_axis);
full_directory = fullfile(parent_directory, directory);
mkdir(full_directory);
pc_names = strings;
for i=1:size(pcCoords_array, 3)
    pc = pointCloud(single(pcCoords_array(:,:,i))); % coordinates have to be float type for the FPFH to be computed
    if numvararg
        filename = strcat(pc_name, prefix, 'm', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)), "_", cutting_plane, cut_ratio);
    else
        filename = strcat(pc_name, prefix, 'm', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)));
    end
    pcwrite(pc,fullfile(full_directory, strcat(filename, '.pcd')),'Encoding','ascii');
    pc_names(end+1) = filename;
end

pc_names = pc_names(1, 2:end);
end


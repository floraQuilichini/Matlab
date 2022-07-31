function [files_names, full_directory] = get_full_path_name(object_name, prefix, mean_vector, sd_vector, theta, rot_axis, trans, parent_directory, varargin)
% function that return the full file path name of the object to be saved

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
full_directory = string(fullfile(parent_directory, directory));
mkdir(full_directory);
files_names = strings;
for i=1:max(size(mean_vector))
    if numvararg
        filename = strcat(object_name, prefix, 'm', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)), "_", cutting_plane, cut_ratio);
    else
        filename = strcat(object_name, prefix, 'm', num2str(mean_vector(i)), '_s', num2str(sd_vector(i)));
    end
    files_names(end+1) = filename;
end

files_names = files_names(1, 2:end);


end


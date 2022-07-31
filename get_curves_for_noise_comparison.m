function get_curves_for_noise_comparison(input_paths, input_subdir_transform, output_path, varargin)
% input_paths is a string array


[l, c] = size(input_paths);
if (max(l, c) == 1 && isempty(varargin))
    get_curves_for_noise_comparison(input_paths, input_subdir_transform, output_path, "");
else
    if nargin-3 ~= max(l, c)
        error('you have to give as many legend names as path number');     
    else
        old_size = 0;
        c2c_params = strings;
        c2m_params = strings;
        name_params = strings(max(l, c), 3);
        sep = repmat("_", max(l, c), 3);
        for k=1:1:max(l, c)
            s = regexp(input_paths(k), filesep, 'split');
            % get filenames
            [c2c_results_filepath, c2m_results_filepath, noise_values] = get_filenames_for_noise_curve_comparison(input_paths(k), input_subdir_transform);
            add_size = 2*size(c2c_results_filepath, 2);
            new_size = old_size + add_size;
            c2c_params(1+old_size:2:new_size) = c2c_results_filepath;
            c2c_params(2+old_size:2:new_size) = noise_values + repmat(varargin{k}, size(noise_values));
            c2m_params(1+old_size:2:new_size) = c2m_results_filepath;
            c2m_params(2+old_size:2:new_size) = noise_values + repmat(varargin{k}, size(noise_values));
            name_params(k, :) = [s(end-2), s(end-1), s(end)];
            old_size = new_size;
        end
        % draw curves for different noise values
        full_name = (name_params + sep)';
            % for c2c metric
        c2c_figure_name = strcat(full_name{:}, 'c2c.png');
        draw_pointCloud_to_pointCloud_compared_mean_distances(output_path, c2c_figure_name, c2c_params{:});
            % for c2m metric
        c2m_figure_name = strcat(full_name{:}, 'c2m.png');
        draw_pointCloud_to_pointCloud_compared_mean_distances(output_path, c2m_figure_name, c2m_params{:});
    end
end
end


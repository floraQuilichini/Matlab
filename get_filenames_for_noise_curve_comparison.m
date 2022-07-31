function [c2c_results_filepath, c2m_results_filepath, noise_values] = get_filenames_for_noise_curve_comparison(input_path, input_subdir_transform)

input_subdir_c2c = 'c2c';
input_subdir_c2m = 'c2m';
c2c_filename = 'c2c_results.txt';
c2m_filename = 'c2m_results.txt';
c2c_results_filepath = strings;
c2m_results_filepath = strings;
noise_values = strings;

% Get a list of all files and folders in this folder.
files = dir(input_path);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Remove directories with '.' or '..' name
dirNames = {subFolders.name};
count = 1;
for i = 1:1:size(dirNames, 2)
    %if (strcmp(dirNames{1, i}, 'm0_s0.0_m0_s0.0') ||  strcmp(dirNames{1, i}, 'm0_s0.0_m0_s0.3') ||strcmp(dirNames{1, i}, 'm0_s0.3_m0_s0.5'))
    if ~ (strcmp(dirNames{1, i}, '.') ||  strcmp(dirNames{1, i}, '..'))
        c2c_results_filepath(count) = fullfile(input_path, dirNames{1, i}, input_subdir_transform, input_subdir_c2c, c2c_filename);
        c2m_results_filepath(count) = fullfile(input_path, dirNames{1, i}, input_subdir_transform, input_subdir_c2m, c2m_filename);
        noise_values(count) = strrep(dirNames{1, i}, '_', '-');
        count = count+1;
    end
end


end


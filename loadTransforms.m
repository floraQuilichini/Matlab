function [T, source_pc_filename, target_pc_filename, bool] = loadTransforms(output_directory, target_directory)
%function that loads all the text files in the output directory that
%contain the computed transforms.
% it returns the transform matrices associated to their point clouds
% (target and source)
% outut files are stored in the same directories as source files

list= dir(output_directory);
T = zeros(4, 4);
source_pc_filename = "";
target_pc_filename = "";
bool = false;
for i = 1:size(list, 1)
    output_filename = list(i).name; % string filename 
    [~, ~, ext] = fileparts(output_filename);
    if strcmp(ext, ".txt")
        bool = true;
        dataT = importdata(strcat(output_directory, '/', output_filename)," ", 1);
        T = dataT.data(:,:);
        % find corresponding pc source and pc target
        [source_pc_filename, target_pc_filename] = findOutputCorrespondingPc(output_directory, output_filename, target_directory);
    end
end


end


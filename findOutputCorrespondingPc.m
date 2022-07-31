function [source_pc_file, source_name, target_pc_file, target_name] = findOutputCorrespondingPc(output_file) ..., source_directory, target_directory )
%

%% previous version of the code (when more information were contained in the output title)

% currentDirectory = pwd;
% 
% [~, name,~] = fileparts(output_file);
%     % extract source file
% [simplification, happened] = str2num(extractBefore(extractAfter(name, "output"), "_"));
% if happened % the source file is in simplified models
%     prefix = extractBefore(extractAfter(name, "_"), "_");
% else  % the source file is in full resoultion models)
%     simplification = "";
%     prefix = extractBefore(extractAfter(name, "_"), "_m");
% end
% source_target_params = extractAfter(name, strcat(prefix, "_"));
% source_params = strcat('m', extractBetween(source_target_params, 'm', 'm'));
% sourcefile_part_name = strcat(num2str(simplification), "_source", prefix, "_", source_params);
% cd(output_directory);
% source_pc_info = dir(strcat('*', sourcefile_part_name, '.pcd'));
% source_pc_file = source_pc_info.name;
% 
% 
%   % extract target file
% target_params = extractAfter(source_target_params, source_params);
% cd(target_directory);
% target_pc_info = dir(strcat('*', '_target_', target_params, '.pcd'));
% target_pc_file = target_pc_info.name;
%     
% cd (currentDirectory);

%% newer version
% currentDirectory = pwd;
% 
% [~, name,~] = fileparts(output_file);
%     % extract source file
% source_params = extractBefore(extractAfter(name, "_"), "_m");
% sourcefile_part_name = strcat("_source_", source_params);
% cd(source_directory);
% source_pc_info = dir(strcat('*', sourcefile_part_name,'.pcd'));
% source_pc_file = source_pc_info.name;
% 
% 
%   % extract target file
% target_params = extractAfter(name, strcat(source_params, "_"));
% cd(target_directory);
% target_pc_info = dir(strcat('*', '_target_', target_params, '.pcd'));
% target_pc_file = target_pc_info.name;
%     
% cd (currentDirectory);


%%  current version
[~, output_name,~] = fileparts(output_file);
params = split(output_name, '_');
source_part = strcat(params(2), extractBetween(output_name, params(2), params(2)));
    % extract target file
target_name = extractAfter(output_name, source_part);
target_pc_file = strcat(target_name, '.pcd');
    % extract source file
source_name = extractBefore(source_part, '_downsampled');
%source_name = source_part{1}(1:1:end-1);

source_pc_file = char(strcat(source_name, '.pcd'));


end


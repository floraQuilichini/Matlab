function registered_target_files = pcRegistration(output_directory, source_directory, target_directory, scale_coeff)
%function that performs all the registrations of source point clouds to target 
%point clouds for files that are in the output directory
% it saves the tranformed source point clouds in 'pcd' format

registered_target_files = strings;
list= dir(output_directory);
for i = 1:size(list, 1)
    output_filename = list(i).name; % string filename 
    [~, ~, ext] = fileparts(output_filename);
    if strcmp(ext, ".txt") && contains(output_filename,'output_')
        dataT = importdata(strcat(output_directory, '/', output_filename)," ", 1);
        % extract Transform
        T = dataT.data(:,:);
        % apply scaling
        scale = inv(compute_scale_matrix(scale_coeff));
        T = scale*T;
        % find corresponding pc source and pc target
        [source_pc_filename, source_name, target_pc_filename, target_name] = findOutputCorrespondingPc(output_filename); ..., source_directory, target_directory);
        % apply Transform (registration from target to source)
        target_pc_transformed = applyTransform(fullfile(output_directory, target_pc_filename), T);
        % store transformed source pc
        mkdir(fullfile(output_directory, 'targetTransformed'));
        registered_target_file = fullfile(output_directory, 'targetTransformed', insertBefore(target_pc_filename,".pcd","Transformed"));
        pcwrite(target_pc_transformed,registered_target_file,'Encoding','ascii');
        registered_target_files(end+1) = registered_target_file;
        % display superimposed transformed source pc and target pc
        %pause;
        source_pc = pcread(fullfile(source_directory,source_pc_filename));
        display_superimposed_pc(source_pc, [0 255 0], target_pc_transformed, [255 0 0]);
        %save figure
        figure_title = strcat("superimposed_point_cloud_", source_name, "_", target_name, ".fig");
        savefig(fullfile(output_directory, 'targetTransformed', figure_title));
        %save transformed matrix
        transform_matrix = inv(T);
        fid = fopen(fullfile(output_directory, 'targetTransformed', char(strcat('transform_matrix_computed_', source_name, '_', target_name, '.txt'))), 'wt');
        for j = 1:1:size(transform_matrix, 1)
            fprintf(fid, '%4.12f\t', transform_matrix(j, :));
            fprintf(fid, '\n');
        end
    end
end

if size(registered_target_files, 2) > 1
    registered_target_files = registered_target_files(1, 2:end);
end

end



function registered_target_file = pcSimpleRegistration_v2(output_directory, output_filename, source_pc_filename, target_pc_name, scale_coeff)
%function that performs all the registrations of source point clouds to target 
%point clouds for files that are in the output directory
% it saves the tranformed source point clouds in 'pcd' format

dataT = importdata(strcat(output_directory, '/', output_filename)," ", 1);

if ~isa(dataT, 'struct')  % check that dataT is correct
    T = eye(4);
else
    % extract Transform
    T = dataT.data(:,:);
    if size(T, 1) ~= 4 && size(T, 1)~= 4      % check that T is correct
        T = eye(4);
    end
end
% apply scaling
scale = inv(compute_scale_matrix(scale_coeff));
T = scale*T;
% apply Transform (registration from target to source)
target_pc_transformed = applyTransform(fullfile(output_directory,target_pc_name), T);
% store transformed source pc
mkdir(fullfile(output_directory, 'targetTransformed'));
registered_target_file = fullfile(output_directory, 'targetTransformed', insertBefore(target_pc_name,".pcd","Transformed"));
pcwrite(target_pc_transformed,registered_target_file,'Encoding','ascii');
% display superimposed transformed source pc and target pc
%pause;
source_pc = pcread(source_pc_filename);
display_superimposed_pc(source_pc, [0 255 0], target_pc_transformed, [255 0 0]);
%save figure
figure_title = char(strcat("superimposed_point_cloud_", extractBetween(output_filename, 'output_', '.txt'), ".fig"));
savefig(fullfile(output_directory, 'targetTransformed', figure_title));
%save transformed matrix
transform_matrix = inv(T);
fid = fopen(fullfile(output_directory, 'targetTransformed', char(strcat('transform_matrix_computed_', extractAfter(output_filename, 'output_')))), 'wt');
for j = 1:1:size(transform_matrix, 1)
    fprintf(fid, '%4.12f\t', transform_matrix(j, :));
    fprintf(fid, '\n');
end

end






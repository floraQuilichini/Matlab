function write_point_descriptor_file(Pts, descriptors, dim_descriptor, descriptor_type, output_dir, output_file_name, output_file_ext, varargin)


numvar = length(varargin);
if numvar ==2
    s = varargin{1};
    source_target_matching_pairs = varargin{2};
    if ~strcmp(s, 'cross_check')
        error('first optional parameter must be "cross_check"');
    end
    if size(source_target_matching_pairs, 2) ~= 2
        error('second optional parameter must be of size n by 2');
    end
    cross_check_flag = 1;
else
    cross_check_flag = 0;
end


if ~(strcmp(output_file_ext, '.bin') || strcmp(output_file_ext, '.txt'))
    error('Extension not handled by the function. The handled extensions are : ".bin" and ".txt"');
end


output_file = fullfile(output_dir, strcat(output_file_name, output_file_ext));

if strcmp(descriptor_type, 'GLS')
    Pts = Pts';
    nb_points = size(Pts, 2);
    scales_size = size(descriptors, 3);
    points_indices = repmat((1:3), 1, nb_points) + repelem((0:3*scales_size+3:(nb_points-1)*(3*scales_size+3)+3), 1, 3); 
    descriptors_indices = repmat((4:3*scales_size+3), 1, nb_points) + repelem((0:3*scales_size+3:(nb_points-1)*(3*scales_size+3)), 1, 3*scales_size); 
    Point_descriptor_vector = zeros(nb_points*(3+3*scales_size), 1);
    Point_descriptor_vector(points_indices) = Pts(:);
    descriptors = permute(descriptors, [2 1 3]);
    Point_descriptor_vector(descriptors_indices) = descriptors(:);
else
    if strcmp(descriptor_type, 'FPFH') || strcmp(descriptor_type, 'RoPS') || strcmp(descriptor_type, 'SHOT')
        Pts = Pts';
        nb_points = size(Pts, 2);
        points_indices = repmat((1:3), 1, nb_points) + repelem((0:dim_descriptor+3:(nb_points-1)*(dim_descriptor+3)+3), 1, 3); 
        descriptors_indices = repmat((4:dim_descriptor+3), 1, nb_points) + repelem((0:dim_descriptor+3:(nb_points-1)*(dim_descriptor+3)), 1, dim_descriptor); 
        Point_descriptor_vector = zeros(nb_points*(3+dim_descriptor), 1);
        Point_descriptor_vector(points_indices) = Pts(:);
        descriptors = descriptors';
        Point_descriptor_vector(descriptors_indices) = descriptors(:);
    else
        error('the only descriptor currently avalaible for this function are "GLS" or "FPFH" or "RoPS" or "SHOT"');
    end
end

if strcmp(output_file_ext, '.bin') 
    fileID = fopen(output_file, 'w');
    fwrite(fileID, nb_points,'uint');
    fwrite(fileID, dim_descriptor,'uint');
    fwrite(fileID, Point_descriptor_vector,'float');
    if cross_check_flag
        source_target_matching_pairs = sortrows(source_target_matching_pairs); % in FGR tuple test, indices are sorted along the i value (source value). We don't have to sort them here, but it will make debugging easier
        source_target_matching_pairs = source_target_matching_pairs - ones(size(source_target_matching_pairs)); % index in FGR tuple test begins at 0 (and not at 1)
        nb_pairs = size(source_target_matching_pairs, 1);
        fwrite(fileID, nb_pairs,'uint');
        fwrite(fileID, source_target_matching_pairs','uint');
    end
    fclose(fileID);
else  
    fileID = fopen(output_file,'w');
    fprintf(fileID,'%u\n', nb_points);
    fprintf(fileID,'%u\n', dim_descriptor);
    fprintf(fileID,'%4.5f\n', Point_descriptor_vector);
    if cross_check_flag
        source_target_matching_pairs = sortrows(source_target_matching_pairs')'; % in FGR tuple test, indices are sorted along the i value (source value). We don't have to sort them here, but it will make debugging easier
        source_target_matching_pairs = source_target_matching_pairs - ones(size(source_target_matching_pairs)); % index in FGR tuple test begins at 0 (and not at 1)
        nb_pairs = size(source_target_matching_pairs, 1);
        fprintf(fileID,'%u\n', nb_pairs);
        fprintf(fileID, '%u %u\n', source_target_matching_pairs');
    end
    fclose(fileID);
end

end


%% roipoly script segmentation

input_filepath = "D:\autoencoder_data\depthmaps\test\dilated";
output_filepath = "D:\autoencoder_data\depthmaps\test\segmentation_roipoly";
depthmaps = dir(input_filepath);

N=length(depthmaps);
for i=1:N
    if ~depthmaps(i).isdir
        depthmap_name=depthmaps(i).name;
        roipoly_segmentation(append(input_filepath, "\", depthmap_name), append(output_filepath, "\", depthmap_name));
    end
end


%% object_extraction_script

depthmap_dir = 'D:\autoencoder_data\depthmaps\test\dilated\';
depthmap_segmented_dir = 'D:\autoencoder_data\depthmaps\test\segmented\';
depthmap_dir_info = dir(depthmap_dir);
for k = 1:size(depthmap_dir_info, 1)
    if ~depthmap_dir_info(k).isdir
        depthmap_name = depthmap_dir_info(k).name;
        depthmap = double(imread(join([depthmap_dir , depthmap_name])));
        [depthmap_segmented] = object_extraction(depthmap);

        % save result
        imwrite(depthmap_segmented, join([depthmap_segmented_dir, depthmap_name]));
    end
end
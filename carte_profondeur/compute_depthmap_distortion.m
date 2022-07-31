%% compute depthmap distortion

test_reconstructed_dir = 'D:\autoencoder_data\depthmaps2\reconstructed\beta_000001_dilated\';
test_dir = 'D:\autoencoder_data\depthmaps\test\dilated\';
mask_dir = 'D:\autoencoder_data\depthmaps\test\mask\';

reconstructed_dir_info = dir(test_reconstructed_dir);
test_dir_info = dir(test_dir);
mask_dir_info = dir(mask_dir);

for k = 1:size(reconstructed_dir_info, 1)
    if ~reconstructed_dir_info(k).isdir
        depthmap_name_reconstructed = reconstructed_dir_info(k).name;
        depthmap_name_test = test_dir_info(k).name;
        mask_name = mask_dir_info(k).name;
        mask = double(imread(join([mask_dir, mask_name])));
        depthmap1 = double(imread(join([test_dir, depthmap_name_test])));
        depthmap2 = double(imread(join([test_reconstructed_dir, depthmap_name_reconstructed])));
        distortion = depthmaps_distortion(depthmap1, depthmap2, mask, mask);
        disp(distortion)
    end
end

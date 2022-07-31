%% compute mask encoding cost

mask_dir = 'D:\autoencoder_data\depthmaps\test\mask\';

mask_dir_info = dir(mask_dir);

for k = 1:size(mask_dir_info, 1)
    if ~mask_dir_info(k).isdir
        mask_name = mask_dir_info(k).name;
        mask = double(imread(join([mask_dir, mask_name])));
        [mask_encoded, nb_bits_for_coding] = rle(mask(:));
        disp(nb_bits_for_coding)
    end
end
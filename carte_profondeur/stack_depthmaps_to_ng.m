%% stack depthmaps

path = 'D:\autoencoder_data\depthmaps\test\';
path_info = dir(path);
output_path = 'D:\autoencoder_data\depthmaps\test\test_ng_stacked\';
for k = 1:size(path_info, 1)
    if ~path_info(k).isdir
        image_name = path_info(k).name;
        image = imread(join([path , image_name]));
        image_ng(:,:, 1) = image;
        image_ng(:,:, 2) = image;
        image_ng(:,:, 3) = image;

        % save result
        imwrite(image_ng, join([output_path, image_name]));
        
        % clear
        clear image_ng
    end
end

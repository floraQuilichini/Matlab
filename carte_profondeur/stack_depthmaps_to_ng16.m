%% stack depthmaps

path = 'C:\Users\root\autoencoder_pytorch\data\intensity\';
path_info = dir(path);
output_path = 'C:\Users\root\autoencoder_pytorch\data\intensity_16\';
for k = 1:size(path_info, 1)
    if ~path_info(k).isdir
        image_name = path_info(k).name;
        image = imread(join([path , image_name]));
        image_ng = uint16((double(image(:, :, 1))/255.0)*65535.0);

        % save result
        imwrite(image_ng, join([output_path, image_name]), 'BitDepth',16);
        
        % clear
        clear image_ng
    end
end
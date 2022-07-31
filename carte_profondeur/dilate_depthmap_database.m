%% dilate depthmap database

% se  = strel('rectangle', [3, 5]);
% %se  = ones(3, 5);
% depthmap_dir = 'D:\autoencoder_data\depthmaps\test\';
% depthmap_dir_info = dir(depthmap_dir);
% for k = 1:size(depthmap_dir_info, 1)
%     if ~depthmap_dir_info(k).isdir
%         depthmap_name = depthmap_dir_info(k).name;
%         depthmap = imread(join([depthmap_dir , depthmap_name]));
%         [depthmap_with_reduced_black_px, mask] = remove_black_px_by_dilatation(depthmap, se);
% 
%         % save result
%             % dilated depthmap
%         imwrite(depthmap_with_reduced_black_px, join([depthmap_dir, 'dilated\', depthmap_name]));
%             % mask
%         imwrite(mask, join([depthmap_dir, 'mask\', depthmap_name]));
%     end
% end



root_dir = 'C:\Users\root\autoencoder_pytorch\data\';
% image_dir = 'C:\Users\root\autoencoder_pytorch\data\flickr\';
image_dir = 'C:\Users\root\autoencoder_pytorch\data\kodac\';
image_dir_info = dir(image_dir);
for k = 1:size(image_dir_info, 1)
    if ~image_dir_info(k).isdir
        image_name = image_dir_info(k).name;
        image = imread(join([image_dir , image_name]));
        intensity_image(:,:, 1) = 0.2126*image(:, :, 1) + 0.7152*image(:, :, 2) + 0.0722*image(:, :, 1);
        intensity_image(:,:, 2) = 0.2126*image(:, :, 1) + 0.7152*image(:, :, 2) + 0.0722*image(:, :, 1);
        intensity_image(:,:, 3) = 0.2126*image(:, :, 1) + 0.7152*image(:, :, 2) + 0.0722*image(:, :, 1);

        % save result
            % dilated depthmap
%         imwrite(intensity_image, join([root_dir, 'intensity\', image_name]));
        imwrite(intensity_image, join([root_dir, 'kodac_intensity\', image_name]));
        
        % clear
        clear intensity_image
    end
end
%% bilateral filtering

image = double(imread('D:\autoencoder_data\depthmaps2\reconstructed\beta_000001\img0.png'));
figure; imshow(image, [0, max(image, [], 'all')]);
patch = image(400:1:400+50, 26:1:26+50);
patch_std = std2(patch);
DoS = 3*patch_std;
image_filtered = image;
for i = 1:size(image, 1)
    for j = 1:size(image, 2)
        image_filtered(i, j) = fix(bilateral_filtering([i, j], image, [35, 35], DoS, 100));
    end
end
figure; imshow(image_filtered, [0, max(image, [], 'all')])
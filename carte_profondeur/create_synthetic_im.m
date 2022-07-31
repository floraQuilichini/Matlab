%% create synthetic images

depthmap = double(imread('D:\autoencoder_data\depthmaps\test\dilated\0000061-000002002155.png'));

sz = [480, 640];
im0 = ones(sz)*max(depthmap, [], 'all');
% im0(190:290, 270:370) = depthmap(190:290, 270:370);
im0(190:290, 270:370) = min(depthmap, [], 'all');
mask0 = zeros(sz);
mask0(190:290, 270:370) = 1;


im1 = im0;
im1(210:270, 290:350) = max(depthmap, [], 'all');
mask1 = mask0;
mask1(210:270, 290:350) = 0;


figure; imshow(im0, []);
figure; imshow(im1, []);

im_stacked(:, :, 1) = im0(180:307, 260:387);
im_stacked(:, :, 2) = im1(180:307, 260:387);
mask_stacked(:,: ,1) = mask0(180:307, 260:387);
mask_stacked(:,: ,2) = mask1(180:307, 260:387);

% sz = size(im_stacked, 3);
% for i =1:sz
%     current_im = mask_stacked(:,:, i).*depthmap;
%     current_im(current_im==0) = min(depthmap, [], 'all');
%     im_stacked(:,:,2+i) = current_im;
%     figure; imshow(im_stacked(:,:,2+i), []);
% end

for i =1:size(im_stacked, 3)
    imwrite(uint16(im_stacked(:,:, i)), "C:\Users\root\Desktop\synthetic_im_test\temp\im" +int2str(i)+ ".png");
end

for i =1:size(mask_stacked, 3)
    imwrite(mask_stacked(:,:, i), "C:\Users\root\Desktop\synthetic_im_test\temp\mask" +int2str(i)+ ".png", 'BitDepth', 1);
end
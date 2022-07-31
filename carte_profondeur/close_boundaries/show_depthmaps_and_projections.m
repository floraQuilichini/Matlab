%% show depthmaps and their projection in 3D space

depthmap_dir = 'D:\autoencoder_data\depthmaps\training\dilated\';
seg_dir = 'E:\CAE_test\cropped\segs\';
depthmap_dir_info = dir(depthmap_dir);
seg_dir_info = dir(seg_dir);
image_size = [128, 128];
principal_point = [319.5, 239.5];
focal_length = 525.0;
skew = 0.0;
scaling_factor = 1000.0;

stack_depthmap = [];
stack_seg = [];
for k = 1:size(depthmap_dir_info, 1)
    if ~depthmap_dir_info(k).isdir
        depthmap_name = depthmap_dir_info(k).name;
        depthmap = double(imread(join([depthmap_dir, depthmap_name])));
        depthmap_normed = (depthmap - min(min(depthmap)))/(max(max(depthmap))- min(min(depthmap)));
        level = graythresh(depthmap_normed);
        stack_depthmap(:, :, k) = depthmap;
        %figure; imshow(depthmap, []);
        if mod(k, 10) == 4
            figure; imshow(depthmap, []);
            figure; imshow(imbinarize(depthmap_normed,level), []);
            figure; imshow(edge(depthmap_normed,'Canny'), []);
            [px1,py1] = gradient(depthmap_normed);
            figure; imshow(sqrt(px1.^2 + py1.^2), []);
        end
        %[pointcloud, ~, ~] = project_depthmap(depthmap,image_size, principal_point, focal_length, skew, scaling_factor);
    end
end


% for k = 1:size(seg_dir_info, 1)
%     if ~seg_dir_info(k).isdir
%         seg_name = seg_dir_info(k).name;
%         seg = double(imread(join([seg_dir, seg_name])))/255;
%         stack_seg(:, :, k) = seg;
%         if k == 4
%             figure; imshow(seg, []);
%         end
%         %[pointcloud, ~, ~] = project_depthmap(depthmap,image_size, principal_point, focal_length, skew, scaling_factor);
%     end
% end
% 
% stack_depthmap_filtered = stack_depthmap .* stack_seg;
% stack_depthmap_diff =stack_depthmap - stack_depthmap_filtered;
% neg_stack_seg = stack_seg;
% neg_stack_seg(neg_stack_seg == 0) = 255;
% neg_stack_seg(neg_stack_seg == 1) = 0;
% neg_stack_seg = neg_stack_seg/255;
% stack_background_filtered = stack_depthmap .* (neg_stack_seg);
% stack_background_diff =stack_depthmap - stack_background_filtered;
% 
% sum_depth = stack_background_diff .* stack_depthmap_diff;
% 
% for k = 1:size(stack_depthmap_diff, 3)
%     if k ==4
%         figure; imshow(stack_depthmap_filtered(:, :, k), []);
%         [px1,py1] = gradient(stack_depthmap_filtered(:, :, k));
%         s1 = graythresh(stack_depthmap_filtered(:, :, k));
%         figure; imshow(edge(stack_depthmap_filtered(:, :, k),'Sobel'))
%         figure; imshow(imbinarize(stack_depthmap_filtered(:, :, k), s1), [])
%         figure; imshow(stack_background_filtered(:, :, k), []);
%         [px2,py2] = gradient(stack_background_filtered(:, :, k));
%         s2 = graythresh(stack_background_filtered(:, :, k));
%         figure; imshow(edge(stack_background_filtered(:, :, k), 'Sobel'))
%         figure; imshow(imbinarize(stack_background_filtered(:, :, k), s2), [])
%         figure; imshow(sum_depth(:, :, k), []);
%     end
% end


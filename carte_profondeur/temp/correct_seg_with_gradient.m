%% correct the segs with gradient

depthmap_dir = 'E:\CAE_test\cropped\depthmaps\';
seg_dir = 'E:\CAE_test\cropped\segs\';
depthmap_dir_info = dir(depthmap_dir);
seg_dir_info = dir(seg_dir);
% image_size = [128, 128];
% principal_point = [319.5, 239.5];
% focal_length = 525.0;
% skew = 0.0;
% scaling_factor = 1000.0;

stack_depthmap = [];
stack_seg = [];
radius = 4;

for k = 1:size(seg_dir_info, 1)
    if ~seg_dir_info(k).isdir
        seg_name = seg_dir_info(k).name;
        seg = double(imread(join([seg_dir, seg_name])))/255;
        stack_seg(:, :, k) = seg;
        %[pointcloud, ~, ~] = project_depthmap(depthmap,image_size, principal_point, focal_length, skew, scaling_factor);
    end
end

for k = 1:size(depthmap_dir_info, 1)
    if ~depthmap_dir_info(k).isdir
        depthmap_name = depthmap_dir_info(k).name;
        depthmap = double(imread(join([depthmap_dir, depthmap_name])));
        depthmap_normed = (depthmap - min(min(depthmap)))/(max(max(depthmap))- min(min(depthmap)));
        stacked_depthmap(:, :, k) = depthmap_normed;
    end
end


for k = 1:size(stacked_depthmap, 3)
    depthmap_normed = stacked_depthmap(:, :, k);
    [px1,py1] = gradient(depthmap_normed);
    depthmap_gradient = sqrt(px1.^2 + py1.^2);
    seg = stack_seg(:, :, k);
    seg_borders  = bwmorph(seg,'remove');
    figure; imshow(seg_borders)
    [l, c] = size(depthmap_normed);
    new_seg = zeros(l, c);
    for i=1:l
        for j=1:c
            if seg_borders(i, j)
                if i-(radius -1)> 0
                    i_beg = i-(radius-1);
                else
                    i_beg = 1;
                end
                if i+(radius-1) > l
                    i_end = l;
                else
                    i_end = i+(radius-1);
                end
                if j-(radius-1) > 0
                    j_beg = j-(radius-1);
                else
                    j_beg = 1;
                end
                if j+(radius-1) > c
                    j_end = c;
                else
                    j_end = j+(radius-1);
                end
                window_grad =  depthmap_gradient(i_beg:i_end, j_beg:j_end);
                window_grad_seg = window_grad > max(max(depthmap_gradient))/4;
                nb_border_grad = sum(window_grad_seg(:) ~= 0);
                window_seg = seg_borders(i_beg:i_end, j_beg:j_end);
                if nb_border_grad > 5
                    if j < radius
                        c_bord_beg = j - (j>1);
                    else
                        c_bord_beg = radius- 1;
                    end
                    c_bord_end = c_bord_beg + 2 - (j==c) - (j==1);
                    
                    if i < radius
                        l_bord_beg = i - (i>1);
                    else
                        l_bord_beg = radius-1;
                    end
                    l_bord_end = l_bord_beg + 2 - (i==l) - (i==1);
                    
                    if (sum(window_seg(:, c_bord_beg:c_bord_end), 'all') > sum(window_seg(l_bord_beg:l_bord_end, :), 'all'))
                        [M, index] = max(window_grad(l_bord_beg + (i>1), :),[], 2, 'linear');
                        new_seg(i, j_beg + index-1) = 1;
                    else
                        [M, index] = max(window_grad(:, c_bord_beg + (j>1)),[], 1, 'linear');
                        new_seg(i_beg + index-1, j) = 1;
                    end
                else
                    new_seg(i, j) = 1;
                end
            end
        end
    end
%     if k ==3
%         new_seg = new_seg(:, 1:end-1);
%     end
    figure; imshow(new_seg);
    figure; imshow(seg);
    figure; imshow(depthmap_gradient, []);
    im_rgb(:,:,1) = seg_borders;
    im_rgb(:,:,2) = depthmap_gradient;
    im_rgb(:,:,3) = new_seg;
    figure; imshow(im_rgb, []);
    
    
end


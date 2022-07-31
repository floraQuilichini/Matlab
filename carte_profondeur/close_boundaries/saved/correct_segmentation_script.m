%% correct the segmentation with gradient
%% inuput parameters
depthmap_dir = 'E:\CAE_test\cropped\depthmaps\';
seg_dir = 'E:\CAE_test\cropped\segs\';
depthmap_dir_info = dir(depthmap_dir);
seg_dir_info = dir(seg_dir);

radius = 4;
ratio = 4;


%% getting the original segmentation images and original dephmap images
stacked_seg = [];
i = 1;
for k = 1:size(seg_dir_info, 1)
    if ~seg_dir_info(k).isdir
        seg_name = seg_dir_info(k).name;
        seg = double(imread(join([seg_dir, seg_name])));
        seg = seg/max(seg, [], 'all');
        stacked_seg(:, :, i) = seg;
        %figure; imshow(seg);
        i = i+1;
    end
end

stacked_depthmap = [];
i=1;
for k = 1:size(depthmap_dir_info, 1)
    if ~depthmap_dir_info(k).isdir
        depthmap_name = depthmap_dir_info(k).name;
        depthmap = double(imread(join([depthmap_dir, depthmap_name])));
        depthmap_normed = (depthmap - min(min(depthmap)))/(max(max(depthmap))- min(min(depthmap)));
        stacked_depthmap(:, :, i) = depthmap_normed;
        %figure; imshow(depthmap_normed, []);
        i = i+1;
    end
end

%% correct the contours of the segmentation by applying the gradient
new_seg_stacked = [];
for k = 1:size(stacked_depthmap, 3)
    depthmap_normed = stacked_depthmap(:, :, k);
    seg = stacked_seg(:, :, k);
    new_seg  = correct_seg_contours_with_grad(depthmap_normed, seg, radius, ratio);  
    new_seg_stacked(:, :, k) = new_seg;
end

%% closing the new contours obtained with gradient
new_seg_closed_stacked = [];
for k = 1:size(new_seg_stacked, 3)
    % collect the boundaries
    new_seg  = new_seg_stacked(:, :, k);
    [stacked_boundaries, additional_ending_leaves] = get_boundaries(new_seg);
    % get the image of boundaries
    im_bounds_bw = get_colored_image_of_borders(new_seg, stacked_boundaries);
    %
    stacked_boundaries = fuse_extremities(stacked_boundaries, new_seg);
    % merge the corners into bounds
    stacked_boundaries = merge_corners(stacked_boundaries);
    % close the boundaries
    im_bounds_closed = join_boundaries(im_bounds_bw, stacked_boundaries, additional_ending_leaves);
    figure; imshow(im_bounds_closed);
    % fill the px inside the closed contour
    im_bounds_filled = imfill(im_bounds_closed);
    new_seg_closed_stacked(:, :, k) = im_bounds_filled;
    figure; imshow(im_bounds_filled);
end
    
function [new_seg, depthmap_gradient, seg_borders, comparison_rgb] = correct_seg_contours_with_grad(depthmap_normed, seg, varargin)

% seg is a binary image (1 or 0 values)
% depthmap must be normalized (values between [0, 1])

nb_var = length(varargin); 
switch nb_var
    case 0
        radius= 4; 
        ratio = 4; 
    case 1
        radius= varargin{:};
        ratio = 4;
    case 2
        radius = varargin{1};
        ratio = varargin{2};
    otherwise
        error('wrong number of optional arguments, max 2');
end


[px1,py1] = gradient(depthmap_normed);
depthmap_gradient = sqrt(px1.^2 + py1.^2);
% patch = imcrop(depthmap_normed, [52, 7, 50, 50]);
% patchVar = std2(patch)^2;
% DoS = 2*patchVar;
% depthmap_filtered = imbilatfilt(depthmap_normed, DoS, 2);
%depthmap_gradient =  edge(depthmap_gradient, 'Sobel', 0.005);
seg_borders  = bwmorph(seg,'remove');
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
            window_grad_seg = window_grad > max(max(depthmap_gradient))/ratio;
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

figure; imshow(seg_borders)
figure; imshow(depthmap_gradient, []);
%figure; imshow(depthmap_filtered, []);
figure; imshow(new_seg);
comparison_rgb(:,:,1) = double(seg_borders);
comparison_rgb(:,:,2) = double(depthmap_gradient);
comparison_rgb(:,:,3) = double(new_seg);
figure; imshow(comparison_rgb, []);

    





















end


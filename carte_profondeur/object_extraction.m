function [image_segmented] = object_extraction(image)

%figure; imshow(image, []);
% compute gradient of the image
Gmag = imgradient(image,'prewitt');
Gmag_n = (Gmag - min(Gmag, [], 'all'))/(max(Gmag, [], 'all') - min(Gmag, [], 'all'));
%figure; imshow(Gmag_n, [])

% threshold the gradient with otsu's method
level = graythresh(Gmag_n);
Gmag_thresh = Gmag_n > 0.6*level;
%figure; imshow(Gmag_thresh)

% close  boundaries (if open)
    % get boundaries from the first segmentation
se = strel('square', 2);
Gmag_closed_min = imclose(Gmag_thresh, se);
Gmag_closed_min = bwareaopen(Gmag_closed_min, 20);
%figure; imshow(Gmag_closed_min);

% fill boundaries
image_segmented_1 = imfill(Gmag_closed_min,'holes');
%figure; imshow(image_segmented_1)
mask = ~(image_segmented_1 - Gmag_closed_min);
%figure; imshow(mask)

    % then dilate the image to close open boundaries and get the new
    % boundaries from new segmentation
se = strel('disk', 9);
Gmag_closed_max = imclose(Gmag_thresh, se);
%figure; imshow(Gmag_closed_max);

% fill boundaries
image_segmented_2 = imfill(Gmag_closed_max,'holes');
%figure; imshow(image_segmented_2)
if sum(image_segmented_1,'all') < 0.6*sum(image_segmented_2,'all')
    image_segmented = image_segmented_2 .* mask;
else
    image_segmented_prev = image_segmented_1;
    image_segmented_curr = image_segmented_2;
    s = 9;
    while sum(image_segmented_prev, 'all') > 0.5*sum(image_segmented_curr, 'all') && s < 30
        image_segmented_prev = image_segmented_curr;
        s = s + 4;
        se = strel('disk', s);
        image_segmented_curr = imclose(image_segmented_prev, se);
        image_segmented_curr = imfill(image_segmented_curr, 'holes');
    end
    if s < 30
        image_segmented = image_segmented_curr .* mask;
    else
        image_segmented = image_segmented_1;
    end
        
end

% fill objects that share a boundary with the image border
borders_l = [image_segmented(1:1:end, 1)', image_segmented(1:1:end, end)'];
borders_L = [image_segmented(1, 1:1:end),  image_segmented(end, 1:1:end)];
indices_l = find(borders_l);
indices_L = find(borders_L);
% remove secondaries connected components
%image_segmented = bwareaopen(image_segmented, fix(size(image, 1)*size(image, 2)*0.03));
%image_segmented = imopen(image_segmented, se);

%figure; imshow(image_segmented)
end


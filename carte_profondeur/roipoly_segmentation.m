function roipoly_segmentation(input_filename, output_filename)
depthmap = double(imread(input_filename));
mask=roipoly(depthmap/max(depthmap, [], 'all'));
    imshow(depthmap, []);
    hold on;
    contour(mask) ;
    imshow(mask);
    imwrite(mask, output_filename,'PNG');
    hold off
end


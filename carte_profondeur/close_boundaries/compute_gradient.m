function  seg_borders = compute_gradient(depthmap_normed)

patch = imcrop(depthmap_normed, [52, 7, 50, 50]);
patchVar = std2(patch)^2;
DoS = 2*patchVar;
depthmap_filtered = imbilatfilt(depthmap_normed, DoS, 2);
% [px1,py1] = gradient(depthmap_normed);
% depthmap_gradient = sqrt(px1.^2 + py1.^2);
seg_borders =  edge(depthmap_filtered, 'Sobel', 0.05);



end


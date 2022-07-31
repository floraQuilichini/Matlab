function distortion = depthmaps_distortion(depthmap1, depthmap2, mask1, mask2)
depthmap1_with_mask = double(depthmap1).*double(mask1);
depthmap2_with_mask = double(depthmap2).*double(mask2);

distortion = sum(abs(depthmap1_with_mask - depthmap2_with_mask), 'all');
end


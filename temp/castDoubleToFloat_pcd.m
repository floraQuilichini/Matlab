function castDoubleToFloat_pcd(pcd_filename)
%function to transform double pcd coordinates into float coordinates
ptCloud = pcread(pcd_filename);
pcFloatCoord = single(ptCloud.Location);
cast_ptCloud = pointCloud(pcFloatCoord);
pcwrite(cast_ptCloud,pcd_filename,'Encoding','ascii');

end


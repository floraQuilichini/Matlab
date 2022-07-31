function d_diagonal = computeBBoxDiagonal(pc_filename)
% return the diagonal length of the bounding box around a point cloud

pc = pcread(pc_filename);
[pmin, pmax] = computeBoundingBox(pc);
d_diagonal = sqrt((pmax - pmin)*(pmax - pmin)');

end


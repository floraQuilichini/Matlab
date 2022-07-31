function target_resized_pc = resize_target_pc_to_source_pc(source_filename, target_filename)


% read pc
target_pc = pcread(target_filename);
source_pc = pcread(source_filename);

% compute pc mean distance between neighbors
source_distance_neighbors = getMeanDistanceBetweenNeighbours(source_pc);
target_distance_neighbors = getMeanDistanceBetweenNeighbours(target_pc);


% compute ratio
r = source_distance_neighbors/target_distance_neighbors;

% resize target pc
target_pc_coords = target_pc.Location;
target_pc_coords_resized = target_pc_coords*r;

% save pc
target_resized_pc = pointCloud(target_pc_coords_resized);

% save pc
pcwrite(target_resized_pc, target_filename,'Encoding','ascii');

end


function register_pcs(source_pc_filename, target_pc_filename, estimated_transform, output_ply_file)

pc_source = pcread(source_pc_filename);
pc_target = pcread(target_pc_filename);
target_registered = [pc_target.Location, ones(pc_target.Count, 1)]*estimated_transform';
target_registered = target_registered(:, 1:3);

figure; pcshow(pc_source.Location, [0 1 0], 'MarkerSize', 40); hold on; pcshow(target_registered, [1 0 0], 'MarkerSize', 40);
pcwrite(pointCloud(target_registered), output_ply_file,'Encoding','ascii');

end


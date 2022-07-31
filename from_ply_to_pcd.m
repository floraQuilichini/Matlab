function from_ply_to_pcd(ply_filename, pcd_filename)

pc = pcread(ply_filename);
pcwrite(pc, pcd_filename, 'Encoding', 'ascii');
end


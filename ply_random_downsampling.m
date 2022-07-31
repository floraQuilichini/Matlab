function ply_random_downsampling(ply_filename, coeff, output_filename)

[faces, Pts, data] = plyread(ply_filename, 'tri');
pointCloud_random_down = pcdownsample(pointCloud(Pts),'random', coeff);
data = reduce_data(data, pointCloud_random_down);
plywrite(data, output_filename, 'ascii');
end


%% depthmaps distances

depthmap_ref = double(imread('D:\autoencoder_data\CAE_test\withSeg1\originals\img1.png'));
depthmaps_q_dir = 'E:\CAE_test\3D\withSeg\';
depthmaps_q_dir_info = dir(depthmaps_q_dir);
image_size = [128, 128];
principal_point = [319.5, 239.5];
focal_length = 525.0;
skew = 0.0;
scaling_factor = 1000.0;
mean_dist = [];
for k = 1:size(depthmaps_q_dir_info, 1)
    if ~depthmaps_q_dir_info(k).isdir
        depthmap_q_name = depthmaps_q_dir_info(k).name;
        depthmap_query = double(imread(join([depthmaps_q_dir, depthmap_q_name])));
        dist = compute_projected_depthmap_distance(depthmap_ref,depthmap_query);
        disp(dist)
        mean_dist(end +1) = dist;
    end
end
mean_dist = mean(mean_dist);
disp(mean_dist)

for k = 1:size(depthmaps_q_dir_info, 1)
    if ~depthmaps_q_dir_info(k).isdir
        depthmap_q_name = depthmaps_q_dir_info(k).name;
        disp(depthmap_q_name)
    end
end
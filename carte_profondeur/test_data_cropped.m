%% crop test data script 

input_filepath = "D:\autoencoder_data\depthmaps\test\dilated";
output_filepath = "D:\autoencoder_data\depthmaps\test\cropped\dilated";
depthmaps = dir(input_filepath);

N=length(depthmaps);
for i=1:N
    if ~depthmaps(i).isdir
        depthmap_name = depthmaps(i).name;
        input_filename = append(input_filepath, "\", depthmap_name);
        output_filename = append(output_filepath, "\", depthmap_name);
        im = imread(input_filename);
        im_cropped = im(150:150+127, 200:200+127);
        imwrite(im_cropped, output_filename, 'BitDepth', 16);
    end
end


input_filepath = "D:\autoencoder_data\depthmaps\test\mask";
output_filepath = "D:\autoencoder_data\depthmaps\test\cropped\mask";
depthmaps = dir(input_filepath);

N=length(depthmaps);
for i=1:N
    if ~depthmaps(i).isdir
        depthmap_name = depthmaps(i).name;
        input_filename = append(input_filepath, "\", depthmap_name);
        output_filename = append(output_filepath, "\", depthmap_name);
        im = imread(input_filename);
        im_cropped = im(150:150+127, 200:200+127);
        imwrite(im_cropped, output_filename);
    end
end



input_filepath = "D:\autoencoder_data\depthmaps\test\segmentation_roipoly";
output_filepath = "D:\autoencoder_data\depthmaps\test\cropped\segmentation_roipoly";
depthmaps = dir(input_filepath);

N=length(depthmaps);
for i=1:N
    if ~depthmaps(i).isdir
        depthmap_name = depthmaps(i).name;
        input_filename = append(input_filepath, "\", depthmap_name);
        output_filename = append(output_filepath, "\", depthmap_name);
        im = imread(input_filename);
        im_cropped = im(150:150+127, 200:200+127);
        imwrite(im_cropped, output_filename);
    end
end
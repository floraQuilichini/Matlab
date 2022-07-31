function [depthmap] = readDepthMap(depthmap_filename)
% written by Arnaud Bletterer

fileID = fopen(depthmap_filename);


%We read two unsigned integers from the file representing the dimensions of the depthmap

width = fread(fileID, 1, 'uint');

height = fread(fileID, 1, 'uint');


%We generate a matlab matrix from the rest of the file as 32 bits floats ('single') with the original dimensions of the depthmap

depthmap = fread(fileID, [width, height], 'single');

fclose(fileID);



%Matrices are read in column-order in Matlab, so we need to transpose the data that has been read

depthmap = transpose(depthmap);


%Images are flipped vertically when generated

depthmap = flip(depthmap,1);



%For visualization only
figure;
imshow(depthmap, [0, 1]);

end


function augDepthMaps = augmentedDepthMaps(depthMap, transform_type, varargin)

numvararg = length(varargin);
if numvararg < 1
    nb_augmented_depthMaps = 1;
else
    if numvararg > 1
        error('too many optional parameters');
    else
        nb_augmented_depthMaps = varargin{1};
    end
end

height = size(depthMap, 1);
width = size(depthMap, 2);

augDepthMaps = ones(height, width, nb_augmented_depthMaps);
crop_object = depthMap(fix(height/4):fix(height/4)+fix(height/2), fix(width/4):fix(width/4)+fix(width/2));

if strcmp(transform_type, 'translation')
    transform_x = randi(fix(height/2), nb_augmented_depthMaps, 1);
    transform_y = randi(fix(width/2),nb_augmented_depthMaps, 1);
    for k=1:nb_augmented_depthMaps
        augDepthMaps(transform_x(k):transform_x(k)+ fix(height/2), transform_y(k):transform_y(k)+ fix(width/2), k) = crop_object;    
    end
    %figure;
    %imshow(augDepthMaps(:, :, 1), [0 1]);
else
    error("this type of transformation has not been implemented yet");
end

end


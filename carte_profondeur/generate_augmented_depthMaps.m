    %% Generate depthMaps
 
D =  "\\wsl$\Ubuntu\home\flora\depth_map_generation\depth_maps\bear\DepthMaps\256x256_12";
S = dir(fullfile(D,'*'));
N = setdiff({S([S.isdir]).name},{'.','..'});
D_saved = "\\wsl$\Ubuntu\home\flora\depth_map_generation\depth_maps\bear\DepthMaps\256x256_12_translated";
for ii = 1:numel(N)
    % get depthMap filename
    T = dir(fullfile(D,N{ii},'*originalDepthMap.dat')); % improve by specifying the file extension.
    depthMap_name = {T(~[T.isdir]).name}; % files in subfolder.
    [~,d_name,d_ext] = fileparts(depthMap_name{1, 1});
    % read depthMap
    fileID = fopen(fullfile(D,N{ii},depthMap_name));
    width = fread(fileID, 1, 'uint');
    height = fread(fileID, 1, 'uint');
    depthMap = fread(fileID, [width, height], 'single');
    fclose(fileID);
    % compute transformed depthMaps
    augDepthMaps = augmentedDepthMaps(depthMap, 'translation', 96);
    % write transformed depthMaps
    nb_augDepthMaps = size(augDepthMaps, 3);
    classFolder = strcat('class_', int2str(ii));
    if ~exist(fullfile(D_saved, classFolder), 'dir')
       mkdir(fullfile(D_saved, classFolder))
    end
    for k=1:nb_augDepthMaps
        fileID = fopen(fullfile(D_saved, classFolder, strcat(d_name, strcat('_shift', int2str(k)), d_ext)),'w');
        fwrite(fileID, width,'uint','ieee-le');
        fwrite(fileID, height,'uint','ieee-le');
        fwrite(fileID, augDepthMaps(:, :, k),'single','ieee-le');
        fclose(fileID);
    end
end
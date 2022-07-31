    %% Generate depthMaps
 
D =  "\\wsl$\Ubuntu\home\flora\depth_map_generation\depth_maps\bear\DepthMaps\51x51_162";
S = dir(fullfile(D,'*'));
N = setdiff({S([S.isdir]).name},{'.','..'});
depthMap_stacked = zeros(51, 51, 2*162);
for ii = 1:numel(N)
    % get depthMap filename
    T = dir(fullfile(D,N{ii},'*originalDepthMap.dat')); % improve by specifying the file extension.
    depthMap_name = {T(~[T.isdir]).name}; % files in subfolder.
    % read depthMap
    depthMap = readDepthMap(fullfile(D,N{ii},depthMap_name));
    depthMap_stacked(:,:, ii)= depthMap;
end

D_ = "\\wsl$\Ubuntu\home\flora\depth_map_generation\depth_maps\bear\DepthMaps\51x51_162_translated";
for ii = 1:numel(N)
    % get depthMap filename
    T = dir(fullfile(D_,'*originalDepthMap.dat')); % improve by specifying the file extension.
    depthMap_name = {T(~[T.isdir]).name}; % files in subfolder.
    % read depthMap
    depthMap = readDepthMap(fullfile(D_,depthMap_name{1, ii}));
    depthMap_stacked(:, :, 162+ii)= depthMap;
end

% query
query_depthMap = readDepthMap("\\wsl$\Ubuntu\home\flora\depth_map_generation\depth_maps\bear\DepthMaps\51x51_642_translated\bear-51x51-DepthCamera_214-originalDepthMap.dat");
minDist_depth = minDist_depthMap(query_depthMap, depthMap_stacked);
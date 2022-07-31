function [pcCoord_transform] = applyTtoPc(pcCoord,T)
% this function apply a rigid transformation to the point cloud coordinates
 
l = size(pcCoord, 1);
homogenous_pcCoord = ones(l, 4);
homogenous_pcCoord(:, 1:3) = pcCoord;
homogenous_pcCoord_transform = homogenous_pcCoord*transpose(T);
pcCoord_transform = homogenous_pcCoord_transform(:, 1:3);
end


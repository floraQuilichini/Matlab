function [r, normal_radius] = getBilateralFilterInputParameters(pc_filename)
% function that compute the input parameters for the bilateral filter for
% point clouds. The parameters are computed in the way recommended in the
% paper https://doi.org/10.5201/ipol.2017.179

% get l (the bounding box size --> as our bounding box is not a cube, we
% computed the major diagonal length and then divided it by sqrt(3))
diag = computeBBoxDiagonal(pc_filename);
l = diag/sqrt(3.0);

% get pc number of points
pc = pcread(pc_filename);
Nb_points = pc.Count;

% get r (the radius used to define the spatial neighborhood)
r = l*sqrt(20/Nb_points);

% we set the normal radius (ie used to define the normal neighborhood)
% equal to r
normal_radius = r;


end


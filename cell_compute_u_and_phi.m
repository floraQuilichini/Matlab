function [u, phi] = cell_compute_u_and_phi(Pts, Normals, Pts_query, radius, varargin)

% radius can be a scalar or a 1 by m vector or a 1 by k vector
% Pts_query is a m by 3 matrix
% Pts is a n by 3 matrix
% Normals is a n by 3 matrix


numvararg = length(varargin);
if numvararg == 1
    if strcmp(varargin{:}, 'Multiscale')
        flag_multiscale = 1;
    else
        error('the only optional parameter is "Multiscale" ');
    end
    
else
    flag_multiscale = 0;
end


if ~flag_multiscale
    
    [l, c] = size(Pts_query);
    [neighbors, dist, indexes] = cell_radius_search(Pts, Pts_query, radius);
    
    % extract normals
    Normals_cell = cell(1, l);
    Normals_cell(:) = {Normals};
    neighbors_normals = cellfun(@get_cell_specific_values, Normals_cell, indexes, 'UniformOutput', false);
    
    % compute w
    if isscalar(radius)
        radius_cell = cell(1, l);
        radius_cell(:) = {radius};
    else
        radius_cell = num2cell(radius);
    end
    w = cellfun(@cell_compute_w, dist, radius_cell, 'UniformOutput', false);

    % compute u 
    u = cellfun(@cell_compute_u, w, neighbors, neighbors_normals, 'UniformOutput', false);

    % compute phi
    phi = cellfun(@cell_compute_phi, u, 'UniformOutput', false);


    % cast to matrix 
    u = cell2mat(u);
    phi = cell2mat(phi);
    
else    % multiscale case
    
    k = size(radius, 2);
    
    [l, c] = size(Pts_query);
    [neighbors, dist, indexes] = cell_radius_search(Pts, Pts_query, radius, 'Multiscale');
    
    % extract normals
    Normals_cell = cell(1, l, k);
    Normals_cell(:) = {Normals};
    neighbors_normals = cellfun(@get_cell_specific_values, Normals_cell, indexes, 'UniformOutput', false);
    
    % compute w 
    radius_cell = mat2cell(reshape(repelem(radius, l), [1, l, k]), 1, ones(1, l), ones(1, k));
    w = cellfun(@cell_compute_w, dist, radius_cell, 'UniformOutput', false);

    % compute u 
    u = cellfun(@cell_compute_u, w, neighbors, neighbors_normals, 'UniformOutput', false);

    % compute phi
    phi = cellfun(@cell_compute_phi, u, 'UniformOutput', false);


    % cast to matrix 
    u = cell2mat(u);
    phi = cell2mat(phi);
    
    
end

end


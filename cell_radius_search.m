function [outputPoints, dist, indexes] = cell_radius_search(Pts, Pts_query, radius, varargin)

% we suppose Pts is a n by 3 matrix and Pts_query a 1 by 3 vector or a m by
% 3 matrix (with m<n)
% radius can be a scalar or a 1 by m vector or a 1 by k vector

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


[l, c] = size(Pts_query);
nb_points = size(Pts, 1);

if ~ flag_multiscale

    if (l ==1) % if Pts_query is a 1 by 3 vector

        % compute distance to Pt_query, for all Pts
        d = sqrt(sum((Pts - repmat(Pts_query, nb_points, 1)).^(2), 2));
        % sort Points by distance to Pts_query
        d_Pts = [d, Pts];
        [d_Pts, indexes] = sortrows(d_Pts);
        % compute output points
        i_d_Pts = [indexes, d_Pts];
        i_d_outputPoints = i_d_Pts(i_d_Pts(:, 2) < radius, :);
        outputPoints = {i_d_outputPoints(:, 3:end)};
        % compute dist
        dist = {i_d_outputPoints(:, 2)};
        % compute indexes
        indexes = {i_d_outputPoints(:, 1)};


    else %  if Pts_query is a m by 3 vector

        if isscalar(radius)
            radius_cell = cell(1, l);
            radius_cell(:) = {radius};
        else
            radius_cell = num2cell(radius);
        end
        
        % compute distance to Pts_query, for all Pts
        d = sqrt(sum((repmat(Pts, l, 1) - repelem(Pts_query, nb_points, 1)).^(2), 2));
        % sort Points by distance to Pts_query
        d = reshape(d,[nb_points,l]);
        [d, indices] = sort(d, 1);
        indices = mod(indices, nb_points);
        indices(indices == 0) = nb_points;
        % compute indexes
        indexes = mat2cell(indices.*(d < radius), nb_points, ones(1, l));
        indexes = cellfun(@remove_zeros_from_cells, indexes, 'UniformOutput', false);
         % compute output points
        outputPoints = cell(1, l);
        outputPoints(:) = {Pts};
        outputPoints = cellfun(@get_cell_specific_values, outputPoints, indexes, 'UniformOutput', false);
        % compute dist
        dist = mat2cell(d, nb_points, ones(1, l));
        dist = cellfun(@compare_cell_to_value, dist, radius_cell, 'UniformOutput', false);

        % % KDTree approach (code from github) - do not work for big amount on data 
    % radius_cell = cell(1, l);
    % radius_cell(:) = {radius};
    % Pts_cell = cell(1, l);
    % Pts_cell(:) = {Pts};
    % Pts_query_cell = mat2cell(Pts_query', 3, ones(1, l));
    %     
    % indexes = cellfun(@cell_KDTree, Pts_cell, Pts_query_cell, radius_cell, 'UniformOutput', false);
    % [dist, outputPoints] = cellfun(@compute_cell_dist, Pts_cell, Pts_query_cell, indexes, 'UniformOutput', false);


    end

else   % multiscale
    
    k = size(radius, 2);
    radius_cell = mat2cell(reshape(repelem(radius, l), [1, l, k]), 1, ones(1, l), ones(1, k));


    % compute distance to Pts_query, for all Pts
    d = sqrt(sum((repmat(Pts, l, 1) - repelem(Pts_query, nb_points, 1)).^(2), 2));
    % sort Points by distance to Pts_query
    d = reshape(d,[nb_points,l]);
    [d, indices] = sort(d, 1);
    indices = mod(indices, nb_points);
    indices(indices == 0) = nb_points;
    % compute indexes
    indexes = mat2cell(repmat(indices, 1, 1, k).*(repmat(d, 1, 1, k) < reshape(repelem(radius, nb_points*l), [nb_points,l, k])), nb_points, ones(1, l), ones(1, k));
    indexes = cellfun(@remove_zeros_from_cells, indexes, 'UniformOutput', false);
     % compute output points
    outputPoints = cell(1, l, k);
    outputPoints(:) = {Pts};
    outputPoints = cellfun(@get_cell_specific_values, outputPoints, indexes, 'UniformOutput', false);
    % compute dist
    dist = mat2cell(repmat(d, 1, 1, k), nb_points, ones(1, l), ones(1, k));
    dist = cellfun(@compare_cell_to_value, dist, radius_cell, 'UniformOutput', false);
            
    
%     %% KDTree approach (code from github) -- ataiya -- works if we cast
%     points to double -- but works less well than code above. Deals with
%     less number of points
%     
%     k = size(radius, 2);
%     outputPoints =  cell(1, l, k);
%     dist = cell(1, l, k);
%     indexes = cell(1, l, k);
%     tree = kdtree_build(double(Pts));
%     for i=1:1:l
%         q = double(Pts_query(i, :));
%         for j=1:1:k
%             rad = radius(j);
%             [idxs, d] = kdtree_ball_query( tree, q, rad);
%             indexes(1, i, j)= {idxs};
%             dist(1, i, j) = {d};
%             outputPoints(1, i, j) = {Pts(idxs, :)}; 
%         end
%     end
%    
    
end


end


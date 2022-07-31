function l2_dist = L2_distance(m, v)
% function that returns the L2-distance (euclidian distance) between a
% vector and a matrix. The function will compute the l2-distance of v with each 
% row (resp column) of m if v is a row-vector (resp column-vector)

[nb_v_coord, dim_v] = max(size(v));
if (size(m, dim_v) ~= nb_v_coord)
    error('v and m must be coherent (ie if v is a row vector with k coordinates, then the number of columns of m must be k)');
else
    if (dim_v == 1)
        v = v';
        m = m';
    end
    nb_m_points = size(m, 1);
    v_matrix = repmat(v, nb_m_points, 1);
    l2_dist = sqrt(sum((m - v_matrix).*(m - v_matrix), 2));
end


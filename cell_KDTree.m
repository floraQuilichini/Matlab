function idxs = cell_KDTree(Pts, Pt_query, radius)

% Pts is a n-by-3 matrix and Pt_query is a 3-by-1 vector

tree = kdtree_build( Pts);
idxs = kdtree_ball_query(tree,Pt_query, radius);

end


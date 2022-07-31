function [dists] = dist_from_point_to_plane(points, plane_coeff)
%points : n-by-3 matrix with point coordinates
% plane coeff : 1-by-four vector with plane coeffs (a,b,c,d)
% point belonging to plane : 1-by-three vector 

nb_points = size(points, 1);
dists = abs(sum(repmat(plane_coeff, nb_points, 1).*[points, ones(nb_points, 1)], 2))/sqrt(sum(plane_coeff(1:3).^(2)));

end


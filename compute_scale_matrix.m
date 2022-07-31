function scale = compute_scale_matrix(scale_coeff)
%function that computes the scale matrix from the scale vector of
%coefficients
scale = eye(4, 4);
for i=1:1:3
    scale(i,i) = scale_coeff(i);
end

end


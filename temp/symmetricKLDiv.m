function symetric_dist = symmetricKLDiv(P, Q, type)
%function that computes the symetric Kullback-Leibler divergence. The user
%can choose between two types ('max' or 'mean')


if ~strcmp(type, 'max') && ~strcmp(type, 'mean')
    error("you must choose between 'max' and 'mean'");
end


dist_P_to_Q = KLDiv(P,Q);
dist_Q_to_P = KLDiv(Q,P);

if strcmp(type, 'max')
    symetric_dist = max(dist_P_to_Q, dist_Q_to_P);
else
    symetric_dist = (dist_P_to_Q + dist_Q_to_P)/2;
end

end


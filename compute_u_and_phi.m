function [uc, ul, uq, phi] = compute_u_and_phi(Pts, Normals, Pt_query, radius)
%this function is used to compute the vector of coefficients u that will be
%used to compute GLS descriptor and one parameter of the GLS descriptor
%(phi)

[neighbors, dist, indexes] = radius_search(Pts, Pt_query, radius);
% extract normals
neighbors_normals = Normals(indexes, :);
% compute w
w = ((dist/radius).^2 - 1).^2;

% compute uq
sum_w = sum(w);
w_n = w/sum_w;
qTn = sum(neighbors.*neighbors_normals, 2);
w_nqT = neighbors.*w_n;
sum_w_nqT = sum(w_nqT, 1);
wnT = neighbors_normals.*w;
sum_wnT = sum(wnT, 1);
num = sum(w.*qTn) - sum_w_nqT*sum_wnT';
% den
qTq = sum(neighbors.*neighbors, 2);
wqT =  neighbors.*w;
sum_wqT = sum(wqT, 1);
den = sum(w.*qTq)- sum_w_nqT*sum_wqT';
% get uq
uq = num/(2*den);

% get ul
w_nnT =  neighbors_normals.*w_n;
ul = sum(w_nnT, 1) - 2*uq*sum_w_nqT;

 % get uc
uc = -ul*sum_w_nqT' - uq*sum(w_n.*qTq);

% get phi
phi = ul*ul' - 4*uc*uq;
grad_suqn = sum((repmat(ul, size(neighbors, 1), 1) + 2*uq*neighbors).*neighbors_normals, 2);
phi_ = sum(w.*grad_suqn)/sum_w;

display(phi)
display(phi_)


end


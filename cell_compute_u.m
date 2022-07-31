function u = cell_compute_u(w, neighbors, neighbors_normals)

if isempty(w)   % case where there is no neighbor in the sphere
    u = single(zeros(5, 1));
elseif size(w, 1)==1   % case where there is only 1 neighbor in the sphere
    u = single(zeros(5, 1));
else
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

    u = [uc, ul, uq]';
end

end


function [T_opt,err_reg] = ransac(source_kpts, target_kpts, target_source_matchings)
%
if length(target_source_matchings) < 4
    error("not enough matching points");
else
    err_reg = realmax;
    nb_matchings = length(target_source_matchings);
    nb_trials = factorial(nb_matchings)/ (factorial(4)*factorial(nb_matchings - 4));
    for i=1:1:nb_trials
        r=randperm(13,4)';
        pairs_indices = target_source_matchings(r,:);
        target_m = zeros(12, 12);
        T = eye(4);
        for j = 1:3
            target_m((j:3:9+j), 1+(j-1)*4:j*4) = [target_kpts(pairs_indices(:, 1), :), ones(4,1)];
        end
        source_pts = source_kpts(pairs_indices(: ,2), :)';
        source_m = source_pts(:);
        T_coeffs = target_m\ source_m;
        for j=1:3
            T(j:4:12+j) = T_coeffs(1+4*(j-1):4*j);
        end
        target_matchings_transformed = T*[target_kpts(target_source_matchings(:,1),:)'; ones(1, length(target_source_matchings))];
        err = sum(sqrt(sum(([source_kpts(target_source_matchings(:,2),:)'; ones(1, length(target_source_matchings))] - target_matchings_transformed).^2, 1)));
        if err < err_reg
            err_reg = err;
            T_opt = T;
        end
    end  
end


end


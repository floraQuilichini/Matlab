function [u_n, pratt_norm] = normalize_u(u)
%function to normalize (pratt norm) the vector of coefficients u.
% used to compute the GLS descriptor
% u is a 1 by 5 vector  or a n by 5 matrix

[l, c, z] = size(u);

if z == 1
    if l ==1    % if vector
        uc = u(1);
        ul = [u(2), u(3), u(4)];
        uq = u(5);

        pratt_norm = sqrt(ul*ul' - 4*uc*uq);
        u_n = u/pratt_norm;
    else    % if matrix
        uc = u(:, 1);
        ul = [u(:, 2), u(:, 3), u(:, 4)];
        uq = u(:, 5);

        pratt_norm = sqrt(sum(ul.^2, 2) - 4*uc.*uq);
        u_n = u./pratt_norm;
    end

else    % multiscale
    
    uc = u(:, 1, :);
    ul = [u(:, 2, :), u(:, 3, :), u(:, 4, :)];
    uq = u(:, 5, :);

    pratt_norm = sqrt(sum(ul.^2, 2) - 4*uc.*uq);
    u_n = u./pratt_norm;
    
end
    

end

